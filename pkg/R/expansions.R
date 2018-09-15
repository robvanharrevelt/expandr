# TODO: when the aggr or expa symbols partially overlap (for example A and BAB),
# then the longest symbol should be evaluated first. The symbols should be
# evaluated in the order of the length of the symbols
#' @importFrom stringr str_replace_all
expand_expression <- function(expr, expa_list) {

  expr <- deparse(expr, width.cutoff = 500L)
  expressions <- expr

  for (pattern in names(expa_list)) {

    if (length(grep(pattern, expr)) == 0) {
      # pattern not in expressions: do not do anything
      next
    }
    expressions <- lapply(expressions, FUN = str_replace_all,
                          pattern = pattern, replacement = expa_list[[pattern]])

    # convert list to character vector
    expressions <- do.call(c, expressions)
  }
  return(expressions)

  return(expr)
}

handle_agg_expr <- function(x, aggn_list) {
  if (is.atomic(x) || is.name(x)) {
    # Leave unchanged
    return(x)
  } else if (is.call(x)) {
    if (identical(x[[1]], quote(agg_expr))) {
      if (length(x) != 2) {
        stop("Incorrect number of argument in agg_expr")
      }
      ret <- handle_agg_expr(x[[2]], aggn_list)
      x <- expand_expression(ret, aggn_list)
      x <- paste(x, collapse = " + ")
      x <- paste0("(", x, ")")
      # convert the string a call tree
      x <- parse(text = x)[[1]]
      return(x)
    } else {
      # Otherwise apply recursively, turning result back into call
      return(as.call(lapply(x, handle_agg_expr, aggn_list)))
    }
  } else {
    # User supplied incorrect input
    stop("Don't know how to handle type ", typeof(x),
         call. = FALSE)
  }
}

handle_single_expression <- function(expr, expa_list, aggn_list) {
  if (length(aggn_list) > 0) {
    expr <- handle_agg_expr(expr, aggn_list)
  }
  if (length(expa_list) > 0) {
    expressions <- expand_expression(expr, expa_list)
    expressions <- lapply(expressions, FUN = function(x) {parse(text = x)})
  } else {
    expressions <- list(as.expression(expr))
  }
  return(expressions)
}

#' Expand R expressions with and without aggregation
#' @param x one or more R-expressions
#'
#' @export
expansions <- function(x) {

  x <- substitute(x)

  pf <- parent.frame()

  if (x[[1]] != "{") {
    # expressions is a single expression. There is nothing to expand
    return(deparse(expressions, width.cutoff = 500))
  }

  # initialisation
  expressions <- list()
  expa_list <- list()
  aggn_list <- list()

  handle_expand_expression <- function(is_aggr) {
    pattern <- names(expr)[2]
    replacements <- expr[[2]]
    if (is_aggr) {
      aggn_list[[pattern]] <<- eval(replacements, envir = pf)
      expa_list[[pattern]] <<- NULL
    } else {
      expa_list[[pattern]] <<- eval(replacements, envir = pf)
      aggn_list[[pattern]] <<- NULL
    }
  }

  for (i in 2 : length(x)) {
    expr <- x[[i]]
    if (expr[[1]] == "expa") {
      handle_expand_expression(FALSE)
    } else if (expr[[1]] == "aggr") {
      handle_expand_expression(TRUE)
    } else {
      expressions <- c(expressions,
                       handle_single_expression(expr, expa_list, aggn_list))
    }
  }

  return(structure(expressions, class = "expansions"))
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
    return(eval(parse(text = expr), envir = pf))
  }
  x <- lapply(expa, FUN = evaluate_expr)
  return (invisible(NULL))
}

#' Evaluate expansions in the environment of a dataframe, list,
#' or timeseries object.
#'
#' @param expa an \code{\link{expansions}} object
#' @param data dataframe, list, \code{\link[stats]{ts}} or
#' \code{\link[regts]{regts}} within which the expanded expressions are
#'  executed
#' @importFrom stats is.ts
#' @importFrom regts as.regts
#' @export
eval_expa_within <- function(expa, data) {
  is_ts <- is.ts(data)
  if (is_ts) {
    data <- as.list(as.regts(data))
  }
  res <- within(data, {
    eval_expa(expa)
  })
  if (is_ts) {
    res <- do.call(cbind, res)
  }
  return(res)
}
