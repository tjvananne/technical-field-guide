# Selenium

I am going to be starting off using Selenium with R. The important part isn't using R, it is learning how Selenium works. I will be using [this basic vignette](https://cran.r-project.org/web/packages/RSelenium/vignettes/RSelenium-basics.html) for my initial guide. 


I am going to try to use the "standalone" install from [this site here](http://selenium-release.storage.googleapis.com/index.html?path=3.1/).


```{r}

install.packages('RSelenium')
library(RSelenium)

# this installs some stuff -- different from the standalone install?
RSelenium::rsDriver()

```


