library(expandr)
library(testthat)
library(regts)

rm(list = ls())

context("Simple expa and aggn examples")

test_that("expa and aggn", {
  expa <- expansions({
    aggr(G = c("m", "v"))
    expa(PROV = c("zh", "nh"))
    PROV_t_2064 <- agg_expr(sqrt(PROV_G_2064))
  })
  expect_equal(as.character(expa),
               c("expression(zh_t_2064 <- (sqrt(zh_m_2064) + sqrt(zh_v_2064)))",
                 "expression(nh_t_2064 <- (sqrt(nh_m_2064) + sqrt(nh_v_2064)))"))
})


test_that("nested aggn", {
  expa <- expansions({
    aggr(G = c("m", "v"))
    aggr(PROV = c("zh", "nh"))
    tot <- agg_expr(sqrt(PROV_2064 + 4 * agg_expr(G_x)))
  })
  expect_equal(as.character(expa),
     "expression(tot <- (sqrt(zh_2064 + 4 * (m_x + v_x)) + sqrt(nh_2064 + 4 * (m_x + v_x))))")
})
