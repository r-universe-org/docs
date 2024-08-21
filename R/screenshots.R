library("chromote")

screenshot <- function(b, path,
                       selector = "html", cliprect = NULL,
                       expand = NULL, height = NULL) {
  img_path <- file.path("img", path)

  b$screenshot(
    img_path,
    selector = selector,
    delay = 2,
    cliprect = cliprect,
    expand = expand
  )

  img <- magick::image_read(img_path)

  if (!is.null(height)) {
   img <- img |>
    magick::image_crop(magick::geometry_area(height = height))

  }

  img |>
    magick::image_shadow() |>
    magick::image_write(img_path, quality = 100)
}

screen_width <- 1920
screen_height <- 1080
b <- ChromoteSession$new(height = screen_height, width = screen_width)

# Landing page ----
b$Page$navigate("https://r-universe.dev/search/")
Sys.sleep(1)
screenshot(b, "search.png")

# Searching for something ----
# https://gist.github.com/oganm/50a8020f718842aa3eee04dcfd57c198
screenshot_search <- function(query, screen_width) {
b$Page$navigate("https://r-universe.dev/search/")
  Sys.sleep(2)
  search_box <- b$DOM$querySelector(b$DOM$getDocument()$root$nodeId, "#search-input")
  b$DOM$focus(search_box$nodeId)
  b$Input$insertText(text = query)
  Sys.sleep(2)
  screenshot(
    b, sprintf("search-%s.png", snakecase::to_lower_camel_case(query)),
    height = height
  )
}
purrr::walk(
  c('"missing-data"', "author:jeroen json", "exports:tojson"),
  screenshot_search,
  screen_width = screen_width
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

# work from an organization ----
b$Page$navigate("https://ropensci.r-universe.dev/builds/")
Sys.sleep(1)
screenshot(b, "univ-builds.png", selector = ".col.p-4")

