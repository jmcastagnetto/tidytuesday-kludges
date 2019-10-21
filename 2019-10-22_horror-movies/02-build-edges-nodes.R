  nodes <- horror_movies_actor %>%
    select(actor) %>%
    distinct() %>%
    mutate(
      id = labels(actor)
    ) %>%
    filter(!is.na(actor))

  edges <- horror_movies_actor %>%
    mutate(
      from_id = labels(actor)
    ) %>%
    group_by(title) %>%
    mutate(
      to_actor = lead(actor)
    ) %>%
    ungroup() %>%
    rename(
      from_actor = actor
    ) %>%
    select(
      from_actor, from_id, to_actor
    ) %>%
    left_join(
      nodes,
      by = c("to_actor" = "actor")
    ) %>%
    rename(
      to_id = id
    ) %>%
    filter(
      !is.na(to_actor)
    )

  save(
    nodes, edges,
    file = here::here("2019-10-22_horror-movies/actors-network.Rdata")
  )

