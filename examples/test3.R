library(expandr)

load("data.Rdata")

print(df)

expa <- expansions({
  aggr(G = c("m", "v"))
  zh_t_2064 <- agg_expr(zh_G_2064) + agg_expr(sin(nh_G_2064) + 1)
})
print(expa)

df2 <- eval_expa_within(expa, df)
print(df2)
