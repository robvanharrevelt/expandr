library(data.table)
library(presim)

input_csv <- "examples/arbeidsaanbod_mev/arbeidsaanbod.csv"
rea_l_ebb <- 2014

# Lees alle tijdreeksen van de input csv
lees_input <- function(filenaam) {
    input <- fread(filenaam, data.table = FALSE)
    rownames(input) <- input[[1]]
    input <- input[-1]
    input <- as.data.frame(t(input))
    rownames(input) <- sub(rownames(input), pattern = "Y", replacement = "")
    return (input)
}

input <- lees_input(input_csv)

# Bevolking -------------------------------------------------------------------

code <- presim({
    "$EXPA"$G <- c("m", "v")
    "$AGGN"$A <- c("1519", "2024", "2529", "3034", "3539", "4044",
                   "4549", "5054", "5559", "6064")
    bv__G_1564 <- "{bv__G_A}"
    bv__G_1574 <- bv__G_1564 + bv__G_6569 + bv__G_7074
    "$AGGN"$A <- c("6569", "7074", "7579", "8084", "8589", "9094",
                   "9599")
    bv__G_6599 <- "{bv__G_A}"
})
print(code)

result <- evaluate_presim_within(code, input)

print(result['bv__m_1564'])

