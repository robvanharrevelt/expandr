library(expandr)

load("examples/data.Rdata")

code <- expansions({
    "@expa"(G = c("m", "v"))
    "@expa"(PROV = c("nh", "zh"))
    PROV_G_2064 <- 888
})
print(code)

print(df)
df2 <- eval_expa_within(code, df)
print(df2)
