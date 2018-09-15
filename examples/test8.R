library(expandr)

load("data.Rdata")

expa <- expansions({
  expa(V = c("wzi", "wli", "nii"))
  expa(G = c("m", "v"))
  aggr(S = c("m", "v"))
  sample <- as.character(1969:2000)
  arb_aanbod[sample, "V_G_1574"] <- agg_expr(arb_aanbod[sample, "V_S_1574_souren"])
})

print(expa)

expa <- expansions({
  expa(V = c("wzi", "wli", "nii"))
  expa(G = c("m", "v"))
  aggr(S = c("m", "v"))
  sample <- as.character(1969:2000)
  arb_aanbod$V_G_1574 <- agg_expr(arb_aanbod$V_S_1574_souren)
})
print(expa)
print(expa)
