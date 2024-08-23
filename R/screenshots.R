library("chromote")

screenshot <- function(b, path,
                       selector = "html",
                       cliprect = c(top = 0, left = 0, width = 1920, height = 1080),
                       expand = NULL) {
  img_path <- file.path("img", path)

  b$screenshot(
    img_path,
    selector = selector,
    delay = 2,
    cliprect = cliprect,
    expand = expand
  )

  magick::image_read(img_path) |>
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
    b, sprintf("search-%s.png", snakecase::to_lower_camel_case(query))
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
  b, "search-advanced.png", selector = "#searchbox", expand = 20
)

# work from an organization ----
screenshot_org <- function(tab, url) {
  b$Page$navigate(sprintf("%s/%s/", url, tab))
  if (tab == "contributors") Sys.sleep(20)
  Sys.sleep(2)
  screenshot(b, sprintf("univ-%s.png", tab))
}
purrr::walk(
  c("builds", "packages", "articles", "contributors"),
  screenshot_org,
  url = "https://ropensci.r-universe.dev/"
)

# about a package ----
pkg_url <- "https://r-spatial.r-universe.dev/sf"
fragments <- c("", "citation", "development", "readme", "manual", "users")
screenshot_pkg <- function(fragment, pkg_url) {
  b$Page$navigate(pkg_url)
  Sys.sleep(4)

  if (!nzchar(fragment)) {
    screenshot(b, sprintf("pkg-%s.png", fragment))
    return()
  }

  section <- b$DOM$querySelector(
    b$DOM$getDocument()$root$nodeId,
    sprintf("#%s", fragment)
  )
  quads <- b$DOM$getBoxModel(section$nodeId)
  screenshot(
    b,
    sprintf("pkg-%s.png", fragment),
    # https://github.com/rstudio/chromote/issues/168
    cliprect = c(top = 0, left = quads$model$margin[[2]], width = 1920, height = 1080)
  )

}
purrr::walk(fragments, screenshot_pkg, pkg_url = pkg_url)

b$Page$navigate("https://r-spatial.r-universe.dev/sf/doc/manual.html")
Sys.sleep(4)
section <- b$DOM$querySelector(
  b$DOM$getDocument()$root$nodeId,
  "#prefix_map"
)
quads <- b$DOM$getBoxModel(section$nodeId)
screenshot(
  b,
  "pkg-function-doc.png",
  # are top and left inverted? it seems so!
  cliprect = c(top = 0, left = quads$model$margin[[2]], width = 1920, height = 1080)
)
