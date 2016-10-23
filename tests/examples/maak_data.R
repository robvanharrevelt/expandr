df <- data.frame(nh_m_2064 = rep(10,2),
                 zh_m_2064 = rep(20,2),
                 nh_v_2064 = rep(2, 2),
                 zh_v_2064 = rep(4, 2),
                 nh_m_6599 = rep(1,2),
                 zh_m_6599 = rep(2,2),
                 nh_v_6599 = rep(0.2, 2),
                 zh_v_6599 = rep(0.4, 2))
rownames(df) <- c("2010", "2011")
print(df)

save(df, file = "examples/data.Rdata")
