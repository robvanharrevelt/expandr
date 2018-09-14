library(expandr)
library(testthat)
library(regts)

context("test the arbeidsaanbod model, the bevolking part")

input <- read_ts_csv("input/bevolking.csv")
colnames(input) <- tolower(colnames(input))
correct_result <- read_ts_csv("refdata/bevolk.csv")

get_leeftijdscategorieen <- function(start, einde) {
  startv <- seq(start, einde - 1, by = 5)
  eindv <- seq(start + 4, einde, by = 5)
  startv <- sapply(startv, FUN = function(x) {sprintf("%02d", x)})
  eindv <- sapply(eindv, FUN = function(x) {sprintf("%02d", x)})
  return(paste0(startv, eindv))
}

expa <- expansions({

  # bereken eerst detotlem
  expa(L = get_leeftijdscategorieen(0, 99))
  aggr(G = c("m", "v"))
  bv__t_L <- agg_expr(bv__G_L)

  expa(G = c("m", "v", "t"))
  aggr(A = get_leeftijdscategorieen(15, 64))
  bv__G_1564 <- agg_expr(bv__G_A)
  aggr(A = get_leeftijdscategorieen(65, 99))
  bv__G_6599 <- agg_expr(bv__G_A)

  bv__G_1574 <- bv__G_1564 + bv__G_6569 + bv__G_7074
  bv__G_1599 <- bv__G_1564 + bv__G_6599
  bv__G_7599 <- bv__G_6599 - bv__G_6569 - bv__G_7074
  bv__G_0099 <- bv__G_0004 + bv__G_0509 + bv__G_1014 + bv__G_1599
  bv__G_2064 <- bv__G_1564 - bv__G_1519
})
#print(expa)

result <- eval_expa_within(expa, input)

dif <- tsdif(result, correct_result, tol = 1e-8, fun = cvgdif)
#print(dif)

test_that("no significant differences", {
  expect_null(dif$dif)
  expect_identical(dif$difnames, character(0))
  expect_identical(dif$missing_names1, character(0))
  expect_identical(dif$missing_names2,
                   paste0("bv__t_", c("9599", "9094", "8589", "8084", "7579")))
  expect_equal(dif$ranges_equal, TRUE)
})
