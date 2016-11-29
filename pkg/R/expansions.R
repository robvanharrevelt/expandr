# TODO: when the aggr or expa symbols partially overlap (for example A and BAB),
# then the longest symbol should be evaluated first. The symbols should be
# evaluated in the order of the length of the symbols
#' @importFrom stringr str_replace_all
expand_expression <- function(expr, expa_list) {
    expressions <- expr
    for (pattern in names(expa_list)) {

        if (length(grep(pattern, expressions)) == 0) {
            # pattern not in expressions: do not do anything
            next
        }
        expressions <- lapply(expressions, FUN = str_replace_all, pattern = pattern,
                              replacement = expa_list[[pattern]])

        # convert list to character vector
        expressions <- do.call(what = c, args = expressions)
    }
    return (expressions)
}



# returns a valid pattern(s) for regular expressions for a normal
# character vector x by escaping characters when necessary
create_pattern <- function(x) {
    return(str_replace_all(x, pattern = "([({)}+*\\[\\]\\\\])",
                           replacement = "\\\\\\1"))
}

get_summation <- function(x, aggn_list) {
    x <- expand_expression(x, aggn_list)
    return(paste(x, collapse = " + "))
}

#' @importFrom stringr str_match_all
perform_aggregation <- function(expr, aggn_list) {
    matches <- str_match_all(expr, pattern  = "\"\\{(.+?)\\}\"")
    groups <- matches[[1]][, 2]
    if (length(groups) == 0) {
        return (expr)
    }
    patterns <- create_pattern(groups)
    replacements <- lapply(groups, FUN = get_summation, aggn_list = aggn_list)
    replacements <- paste0("(", as.character(replacements), ")")
    pattern_list <- replacements
    names(pattern_list) <- paste0("\"\\{", patterns, "\\}\"")
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

    handle_expand_expression <- function(is_aggr) {
        pattern <- names(expr)[2]
        replacements <- expr[[2]]
        if (is_aggr) {
            aggn_list[[pattern]] <<- eval(replacements)
            expa_list[[pattern]] <<- NULL
        } else {
            expa_list[[pattern]] <<- eval(replacements)
            aggn_list[[pattern]] <<- NULL
        }
    }

    for (i in 2 : length(x)) {
        expr = x[[i]]
        if (expr[[1]] == "@expa") {
            handle_expand_expression(FALSE)
         } else if (expr[[1]] == "@aggr") {
            handle_expand_expression(TRUE)
        } else {
            expr <- deparse(expr, width.cutoff = 500L)
            expressions <- c(expressions,
                         handle_single_expression(expr, expa_list, aggn_list))
        }
    }
    return (structure(expressions, class = "expansions"))
}

#' @export
print.expansions <- function(x, ...) {
    cat("S3 class expansions\n")
    cat(paste(x, collapse = "\n"))
    cat("\n")
}

#' Evaluate expansions in the parent environment
#'
#' @param expa an <code>expansions</code> object
#' @export
eval_expa <- function(expa) {
    pf <- parent.frame()
    evaluate_expr <- function(expr) {
        return (eval(parse(text = expr), envir = pf))
    }
    x <- lapply(expa, FUN = evaluate_expr)
    return (invisible(NULL))
}

#' Evaluate expansions in the environment of a dataframe or list
#'
#' @param expa an <code>expansions</code> object
#' @param data dataframe or list within which the expanded expressions are
#'  executed
#' @export
eval_expa_within <- function(expa, data) {
    res <- within(data, {
        eval_expa(expa)
    })
    return (res)
}
