library(expandr)

load("data.Rdata")

expa <- expansions({
  expa(G = c("m", "v"))
  expa(PROV = c("nh", "zh"))
  expa(X = c("1", "2"))
  PROV_G_2064_X <- 888
})
print(expa)

print(df)
df2 <- eval_expa_within(expa, df)
print(df2)
