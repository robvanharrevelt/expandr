library(expandr)
library(stringr)
context("Simple expa and aggn examples")

test_that("expa and aggn", {
    expa <- expansions({
        "@aggr"(G = c("m", "v"))
        "@expa"(PROV = c("zh", "nh"))
        PROV_t_2064 <- "{sqrt(PROV_G_2064)}"
    })
    expect_equal(as.character(expa),
                 c("zh_t_2064 <- sqrt(zh_m_2064) + sqrt(zh_v_2064)",
                   "nh_t_2064 <- sqrt(nh_m_2064) + sqrt(nh_v_2064)"))
})
