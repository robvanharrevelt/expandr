library(presim)

load("examples/data.Rdata")

code <- presim({
    "$EXPA"$G = c("m", "v")
    "$EXPA"$PROV = c("nh", "zh")
    PROV_G_2064 <- 888
})
print(code)

print(df)
df2 <- evaluate_presim_within(code, df)
print(df2)
