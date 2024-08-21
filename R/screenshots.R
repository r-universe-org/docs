library("chromote")

screenshot <- function(b, path, selector, cliprect = NULL, expand = NULL) {
  b$screenshot(
    file.path("img", path),
    selector = selector,
    delay = 2,
    cliprect = cliprect,
    expand = expand
  )
}

# Landing page ----
b <- ChromoteSession$new()
b$Page$navigate("https://r-universe.dev/search/")
screenshot(b, "search.png", selector = ".col.p-4")

# Searching for something ----
# https://gist.github.com/oganm/50a8020f718842aa3eee04dcfd57c198
screenshot_search <- function(query) {
b$Page$navigate("https://r-universe.dev/search/")
  Sys.sleep(2)
  search_box <- b$DOM$querySelector(b$DOM$getDocument()$root$nodeId, "#search-input")
  b$DOM$focus(search_box$nodeId)
  b$Input$insertText(text = query)
  Sys.sleep(2)
  screenshot(
    b, sprintf("search-%s.png", snakecase::to_lower_camel_case(query)),
    selector = ".col.p-4",
    cliprect = c(left = 0, top = 0, width = 1000, height = 1500)
  )
}
purrr::walk(
  c('"missing-data"', "author:jeroen json", "exports:tojson"),
  screenshot_search
)
# Searching, advanced fields ----
b$Page$navigate("https://r-universe.dev/search/")
Sys.sleep(1)
search_info <- b$DOM$querySelector(b$DOM$getDocument()$root$nodeId, "button.btn.btn-outline-secondary.dropdown-toggle.dropdown-toggle-split")
quads <- b$DOM$getBoxModel(search_info$nodeId)
content_quad <- as.numeric(quads$model$content)
center_x <- mean(content_quad[c(1, 3, 5, 7)])
center_y <- mean(content_quad[c(2, 4, 6, 8)])
b$Input$dispatchMouseEvent(
  type = "mouseMoved",
  x = center_x,
  y = center_y,
)
b$Input$dispatchMouseEvent(
  type = "mousePressed",
  x = center_x,
  y = center_y,
  button = "left",
  clickCount = 1
)
b$Input$dispatchMouseEvent(
  type = "mouseReleased",
  x = center_x,
  y = center_y,
  button = "left",
  clickCount = 1
)
Sys.sleep(2)
screenshot(
  b, "search-advanced.png", selector = "#searchbox"
)


