#-------------------------------------------
#- 1-) Gráficos utilizados na apresentação - 
#-------------------------------------------

# Importar bibliotecas
source("code/01-config.R")

# Importa o arquivo final
df_analise_final <- readxl::read_xlsx(path = here("data", "ouro", glue("2025-08-24-df_analise_final.xlsx")))

# Gráfico de match 650 e bolsas distribuídas por UF

g_1 <- df_analise_final %>% 
  group_by(sg_uf) %>% 
  reframe(match_550 = sum(match_550, na.rm=T), match_650 = sum(match_650, na.rm=T), qtd_bolsas_distribuidas = sum(qtd_bolsas_distribuidas, na.rm=T))
g_1 <- reshape2::melt(data=g_1)

g_1 <- ggplot(g_1, aes(x = reorder(sg_uf, value), y = value, fill = variable)) +
  geom_col(position = "identity") +
  coord_flip() +
  scale_fill_manual(
    values = c(match_650 = "darkblue", match_550 = "#00008B80", qtd_bolsas_distribuidas = "#00008B1A"),
    labels = c(match_650 = "Match 650", match_550 = "Match 550", qtd_bolsas_distribuidas = "Bolsas distribuídas")
  ) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(face = "bold"),
    legend.title = element_blank()
  )

ggsave(here("output", "match_650_bolsas_uf.png"), plot = g_1, width = 8, height = 6, units = "in")

# Gráfico de match 650 e bolsas distribuídas por curso

g_2 <- df_analise_final %>% 
  group_by(no_curso_aj) %>% 
  reframe(match_550 = sum(match_550, na.rm=T), match_650 = sum(match_650, na.rm=T), qtd_bolsas_distribuidas = sum(qtd_bolsas_distribuidas, na.rm=T))
g_2 <- reshape2::melt(data=g_2)

g_2 <- ggplot(g_2, aes(x = reorder(no_curso_aj, value), y = value, fill = variable)) +
  geom_col(position = "identity") +
  coord_flip() +
  scale_fill_manual(
    values = c(match_650 = "darkblue", match_550 = "#00008B80", qtd_bolsas_distribuidas = "#00008B1A"),
    labels = c(match_650 = "Match 650", match_550 = "Match 550", qtd_bolsas_distribuidas = "Bolsas distribuídas")
  ) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(face = "bold"),
    legend.title = element_blank()
  )

ggsave(here("output", "match_650_bolsas_curso.png"), plot = g_2, width = 8, height = 6, units = "in")

# Gráfico de demanda e bolsas distribuídas por UF

g_3 <- df_analise_final %>% 
  group_by(sg_uf) %>% 
  reframe(demanda = sum(demanda, na.rm=T), qtd_bolsas_distribuidas = sum(qtd_bolsas_distribuidas, na.rm=T))
g_3 <- reshape2::melt(data=g_3)

g_3 <- ggplot(g_3, aes(x = reorder(sg_uf, value), y = value, fill = variable)) +
  geom_col(position = "identity") +
  coord_flip() +
  scale_fill_manual(
    values = c(demanda = "#00008B1A", qtd_bolsas_distribuidas = "darkblue"),
    labels = c(demanda = "Demanda", qtd_bolsas_distribuidas = "Bolsas distribuídas")
  ) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(face = "bold"),
    legend.title = element_blank()
  )

ggsave(here("output", "demanda_bolsas_uf.png"), plot = g_3, width = 8, height = 6, units = "in")

# Gráfico de demanda e bolsas distribuídas por curso

g_4 <- df_analise_final %>% 
  group_by(no_curso_aj) %>% 
  reframe(demanda = sum(demanda, na.rm=T), qtd_bolsas_distribuidas = sum(qtd_bolsas_distribuidas, na.rm=T))
g_4 <- reshape2::melt(data=g_4)

g_4 <- ggplot(g_4, aes(x = reorder(no_curso_aj, value), y = value, fill = variable)) +
  geom_col(position = "identity") +
  coord_flip() +
  scale_fill_manual(
    values = c(demanda = "#00008B1A", qtd_bolsas_distribuidas = "darkblue"),
    labels = c(demanda = "Demanda", qtd_bolsas_distribuidas = "Bolsas distribuídas")
  ) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(face = "bold"),
    legend.title = element_blank()
  )

ggsave(here("output", "demanda_bolsas_curso.png"), plot = g_4, width = 8, height = 6, units = "in")

#-----------------------------------------
#- 2-) Análise de demanda por UF e curso - 
#-----------------------------------------

g_5 <- df_analise_final %>% 
  group_by(sg_uf, no_curso_aj) %>% 
  reframe(match_650 = sum(match_650), qtd_bolsas_distribuidas = sum(qtd_bolsas_distribuidas)) %>% 
  filter(match_650 - qtd_bolsas_distribuidas > 0) %>% 
  pivot_longer(
    cols = c(match_650, qtd_bolsas_distribuidas),
    names_to = "variavel", values_to = "valor"
  )

g_5 <- ggplot(g_5,
       aes(x = reorder(interaction(sg_uf, no_curso_aj), valor),  # UF + curso
           y = valor,
           fill = variavel)) +
  geom_col(position = "identity") +
  coord_flip() +
  scale_fill_manual(values = c("match_650" = "#00008B1A",
                               "qtd_bolsas_distribuidas" = "darkblue"),
                    labels = c("match_650" = "Match 650 (demanda e nota igual ou maior que 650 no Enem)",
                               "qtd_bolsas_distribuidas" = "Bolsas distribuídas")) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(face = "bold"),
    legend.title = element_blank(),
    legend.position = "top"
  )

ggsave(here("output", "match_650_versus_bolsas.png"), plot = g_5, width = 8, height = 6, units = "in")


g_6 <- df_analise_final %>% 
  group_by(sg_uf, no_curso_aj) %>% 
  reframe(match_550 = sum(match_550), qtd_bolsas_distribuidas = sum(qtd_bolsas_distribuidas)) %>% 
  filter(match_550 - qtd_bolsas_distribuidas > 0) %>% 
  pivot_longer(
    cols = c(match_550, qtd_bolsas_distribuidas),
    names_to = "variavel", values_to = "valor"
  )

g_6 <- ggplot(g_6,
              aes(x = reorder(interaction(sg_uf, no_curso_aj), valor),  # UF + curso
                  y = valor,
                  fill = variavel)) +
  geom_col(position = "identity") +
  coord_flip() +
  scale_fill_manual(values = c("match_550" = "#00008B1A",
                               "qtd_bolsas_distribuidas" = "darkblue"),
                    labels = c("match_550" = "Match 550 (demanda e nota igual ou maior que 550 no Enem)",
                               "qtd_bolsas_distribuidas" = "Bolsas distribuídas")) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(face = "bold"),
    legend.title = element_blank(),
    legend.position = "top"
  )

ggsave(here("output", "match_550_versus_bolsas.png"), plot = g_6, width = 8, height = 6, units = "in")


