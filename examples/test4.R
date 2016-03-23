library(expandr)

load("examples/data.Rdata")

print(df)

df2 <- within(df, {
    eval_expa(expansions({
            "@aggr"(G = c("m", "v"))
            zh_t_2064 <- "@zh_G_2064@" + "@sin(nh_G_2064) + 1@"
            zh_t_6599 <- "@zh_G_6599@" + "@sin(nh_G_6599) + 1@"
        }))
})
print(df2)

expa <- expansions({
    "@aggr"(G = c("m", "v"))
    "@expa"(PROV= c("zh", "nh"))
    PROV_t_2064 <- "@PROV_G_2064@" + "@sin(PROV_G_2064) + 1@"
    PROV_t_6599 <- "@PROV_G_6599@" + "@sin(PROV_G_6599) + 1@"
})
print(expa)
df3 <- eval_expa_within(expa, df)
print(df3)
