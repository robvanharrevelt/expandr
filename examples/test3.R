library(expandr)

load("examples/data.Rdata")

print(df)

expa <- expansions({
    "@aggr"(G = c("m", "v"))
    zh_t_2064 <- "{zh_G_2064}" + "{sin(nh_G_2064) + 1}"
})
print(expa)

df2 <- eval_expa_within(expa, df)
print(df2)
