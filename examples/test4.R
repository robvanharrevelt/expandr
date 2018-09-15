library(expandr)

load("data.Rdata")

print(df)

df2 <- within(df, {
  eval_expa(expansions({
    aggr(G = c("m", "v"))
    zh_t_2064 <- agg_expr(zh_G_2064) + agg_expr(sin(nh_G_2064) + 1)
    zh_t_6599 <- agg_expr(zh_G_6599) + agg_expr(sin(nh_G_6599) + 1)
  }))
})
print(df2)

expa <- expansions({
  aggr(G = c("m", "v"))
  expa(PROV= c("zh", "nh"))
  PROV_t_2064 <- agg_expr(PROV_G_2064) + agg_expr(sin(PROV_G_2064) + 1)
  PROV_t_6599 <- agg_expr(PROV_G_6599) + agg_expr(sin(PROV_G_6599) + 1)
})
print(expa)
df3 <- eval_expa_within(expa, df)
print(df3)
