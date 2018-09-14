library(expandr)

load("examples/data.Rdata")

z <- 888
expa <- expansions({
    expa(G = c("m", "v"))
    zh_G_2064 <- z
})
print(expa)

print(df)

df2 <- within(df, {
    eval_expa(expa)
})
print(df2)

df3 <- eval_expa_within(expa, df)
print(df3)

expa <- expansions({
    expa(G = c("m", "v"))
    df4["2011", "zh_G_2064"] <- 888
})
print(expa)
df4 <- df
x <- eval_expa(expa)
print(df4)
