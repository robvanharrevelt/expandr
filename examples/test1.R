library(presim)

load("examples/data.Rdata")

z <- 888
code <- presim({
    "$expa"(G = c("m", "v"))
    zh_G_2064 <- z
})
print(code)

print(df)

df2 <- withi?n(df, {
    evaluate_presim(code)
})
print(df2)

df3 <- evaluate_presim_within(code, df)
print(df3)

code <- presim({
    "@expa"(G = c("m", "v"))
    df4["2011", "zh_G_2064"] <- 888
})
print(code)
df4 <- df
x <- evaluate_presim(code)
print(df4)
