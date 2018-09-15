library(expandr)

expa <- expansions({
  aggr(B = c("m", "v"))
  aggr(C = c("nh", "zh"))
  expa(C = NULL)
  expa(C = c("nh", "zh"))
  zh_t_6599 <- agg_expr(B_C_6599)
})
print(expa)
