library(presim)

load("examples/data.Rdata")

print(df)

code <-  presim({
    "$AGGN"$G = c("m", "v")
    zh_t_2064 <- "{zh_G_2064}" + "{sin(nh_G_2064) + 1}"
})

df2 <- evaluate_presim_within(code, df)
print(df2)
