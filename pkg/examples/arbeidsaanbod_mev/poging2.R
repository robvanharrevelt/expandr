library(expandr)
library(regts)

input_csv <- "arbeidsaanbod.csv"

input <- read_ts_csv(input_csv)

# Bevolking -------------------------------------------------------------------

expa <- expansions({
    "@expa"(G = c("m", "v"))
    "@aggr"(A = c("1519", "2024", "2529", "3034", "3539", "4044",
                   "4549", "5054", "5559", "6064"))
    bv__G_1564 <- "{bv__G_A}"
    bv__G_1574 <- bv__G_1564 + bv__G_6569 + bv__G_7074
    "@aggr"(A = c("6569", "7074", "7579", "8084", "8589", "9094",
                   "9599"))
    bv__G_6599 <- "{bv__G_A}"
})
print(expa)

result <- eval_expa_within(expa, input)
