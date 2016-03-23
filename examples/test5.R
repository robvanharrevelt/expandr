library(expandr)

load("examples/data.Rdata")

code <- expansions({
    "@aggr"(G = c("m", "v"))
    zh_t_2064 <- "{zh_G_2064}"
    "@aggr"(G1 = c("m", "v"))
    zh_t_6599 <- "{zh_G1_6599}"
})
print(code)
