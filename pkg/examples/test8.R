library(expandr)

expa <- expansions({
    "@expa"(V = c("wzi", "wli", "nii"))
    "@expa"(G = c("m", "v"))
    "@aggr"(S = c("m", "v"))
    sample <- as.character(1969:2000)
    #arb_aanbod[sample, "V_G_1574"] <- "{ arb_aanbodS[sample*, 2]}"
    arb_aanbod[sample, "V_G_1574"] <- "{ arb_aanbod[sample, \"V_S_1574_souren\"] }"
})

print(expa)
