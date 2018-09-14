library(expandr)

load("examples/data.Rdata")

expa <- expansions({
    "@aggr"(B = c("m", "v"))
    zh_t_2064 <- "{zh_B_2064}"
    "@aggr"(ABA = c("m", "v"))
    zh_t_6599 <- agg_expr(zh_ABA_6599)
})
print(expa)


expa <- expansions({
    "@aggr"(B = c("m", "v"))
    zh_t_2064 <- agg_expr(a)
})
print(expa)

expa <- expansions({
    "@expa"(L = c("0004", "0509", "1014"))
    "@aggr"(S = c("m", "v"))
    bv__t_L <- agg_expr(bv__S_L)
})
print(expa)
