#' @import stringr

expand_expression <- function(expr, expa_list) {
    expressions <- expr
    for (pattern in names(expa_list)) {

        # TODO: if pattern not in expression, then do not do anything
        expressions <- lapply(expressions, FUN = str_replace_all, pattern = pattern,
                              replacement = expa_list[[pattern]])

        # convert list to character vector
        expressions <- do.call(what = c, args = expressions)
    }
    return (expressions)
}

evaluate_expr <- function(expr, envir, enclos = NULL) {
    expr <- parse(text = expr)
    return (eval(expr, envir = envir))
}

# returns a valid pattern(s) for regular expressions for a normal
# character vector x by escaping characters when necessary
create_pattern <- function(x) {
    return(str_replace_all(x, pattern = "([({)}+*])", replacement = "\\\\\\1"))
}

get_summation <- function(x, aggn_list) {
    x <- expand_expression(x, aggn_list)
    return(paste(x, collapse = " + "))
}

perform_aggregation <- function(expr, aggn_list) {

    # TODO: the code cannot handle multi-dimensional aggregations yet
    matches <- str_match_all(expr, pattern  = "\"@(.+?)@\"")

    # TODO: if no match, then return and keep exp unchanged
    groups <- matches[[1]][, 2]

    if (length(groups) == 0) {
        return (expr)
    }
    patterns <- create_pattern(groups)

    replacements <- lapply(groups, FUN = get_summation, aggn_list = aggn_list)
    replacements <- as.character(replacements)

    pattern_list <- replacements

    names(pattern_list) <- paste0("\"@", patterns, "@\"")

    expr <- str_replace_all(expr, pattern_list)
    return (expr)
}

handle_single_expression <- function(expr, expa_list, aggn_list) {

    if (length(aggn_list) > 0) {
        expr <- perform_aggregation(expr, aggn_list)
    }

    if (length(expa_list) > 0) {
        expressions <- expand_expression(expr, expa_list)
    } else {
        expressions <- expr
    }

    return (expressions)

}

#' Expand R expressions with and without aggregation
#' @param x one or more R-expressions
#'
#' @export
expansions <- function(x) {
    x <- substitute(x)

    if (x[[1]] != "{") {
        # expressions is a single expression. There is nothing
        # to expand
        return (deparse(expressions, width.cutoff = 500))
    }

    # initialisation
    expressions <- character(0)
    expa_list <- list()
    aggn_list <- list()

    for (i in 2 : length(x)) {
        expr = x[[i]]
        if (expr[[1]] == "@expa") {
            pattern <- names(expr)[2]
            replacements <- expr[[2]]
            expa_list[[pattern]] <- eval(replacements)
        } else if (expr[[1]] == "@aggr") {
            pattern <- names(expr)[2]
            replacements <- expr[[2]]
            aggn_list[[pattern]] <- eval(replacements)
        } else {
            expr <- deparse(expr, width.cutoff = 500L)
            expressions <- c(expressions,
                         handle_single_expression(expr, expa_list, aggn_list))
        }
    }
    return (structure(expressions, class = "expansions"))
}

#' @export
print.expansions <- function(x) {
    cat("S3 class expansions\n")
    cat(paste(x, collapse = "\n"))
    cat("\n")
}

#' Evaluate expansions in the parent environment
#'
#' @param an <code>expansions</code> object
#' @export
eval_expa <- function(code) {
    x <- lapply(code, FUN = evaluate_expr, envir = parent.frame())
    return (NULL)
}

#' Evaluate expansions in the environment of a dataframe or list
#'
#' @param an <code>expansions</code> object
#' @param within dataframe or list within which the expanded expressions are
#'  executed
#' @export
eval_expa_within <- function(code, x) {
    res <- within(x, {
        eval_expa(code)
    })
    return (res)
}
