#!/usr/bin/env Rscript

# 需要安装的 R 程序包列表
Rprograms <- c(
  "argparse", "corrplot",
  "data.table", "e1071", "ggplot2", "gridExtra",
   "matrixStats", "openxlsx",
  "parallel", "reshape", "RPMM",  "stringr", "ggseqlogo",
  "UpSetR", "VennDiagram", "usethis", "devtools"
)

# 中国大陆的 CRAN 镜像列表
cran_mirrors <- c(
  "https://mirrors.ustc.edu.cn/CRAN/",
  "https://cloud.r-project.org/",
  "https://mirrors.bfsu.edu.cn/CRAN/",
  "https://mirrors.sjtug.sjtu.edu.cn/CRAN/",
  "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"
)

# 设置颜色代码，用于终端输出显示不同颜色
# 如果终端不支持颜色，这些设置将被忽略
blue <- "\033[34m"
green <- "\033[32m"
red <- "\033[31m"
nc <- "\033[0m"  # 无颜色

# 遍历每个程序包，尝试使用每个镜像进行安装
for (prog in Rprograms) {
  cat(sprintf("%s正在安装 R 程序包: %s...%s\n", blue, prog, nc))
  
  install_success <- FALSE  # 标记当前安装是否成功
  
  if (requireNamespace(prog, quietly = TRUE)){
    install_success <- TRUE
    cat(sprintf("%s程序包 %s 已经安装。%s\n", blue, prog, nc))
    
  }
  else{
    for (mirror in cran_mirrors) {
      cat(sprintf("尝试使用镜像: %s\n", mirror))
      
      # 尝试安装程序包
      install_result <- tryCatch({
        install.packages(prog, repos = mirror, dependencies = TRUE)
        0  # 成功时返回0
      }, warning = function(w) {
        cat(sprintf("%s警告: %s%s\n", red, w, nc))
        1  # 警告时返回1
      }, error = function(e) {
        cat(sprintf("%s错误: %s%s\n", red, e, nc))
        1  # 错误时返回1
      })
      
      load_result <- tryCatch({
        library(prog, character.only = TRUE)
        0  # 成功时返回0
      })
      
      # 如果安装成功，跳出镜像循环
      if (load_result == 0) {
        install_success <- TRUE
        break
      }
    }
    
  }
  
  # 根据安装结果输出相应信息
  if (install_success) {
    if (requireNamespace(prog, quietly = TRUE)) {
      version <- packageVersion(prog)
      cat(sprintf("%s程序包 %s 安装成功，版本: %s%s\n", green, prog, version, nc))
    } 
  } 
}

# 接下来使用BiocManager安装另一些需求包 
library(devtools)
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.20", update = TRUE, ask = FALSE)

RprogramsNeedsBioc <- c(
  "GenomicRanges","IRanges", "Rsamtools","BSgenome.Hsapiens.UCSC.hg19","DEXSeq",
  "edgeR", "ggbio", 
  "IlluminaHumanMethylation450kanno.ilmn12.hg19", "Rsubread",
  "JASPAR2018", "TFBSTools" , "wateRmelon"
)
packages_string <- toString(RprogramsNeedsBioc)
cat(sprintf("%s正在使用BiocManager安装 R 程序包: %s...%s\n", blue, packages_string, nc))
suppressMessages({
  BiocManager::install(RprogramsNeedsBioc, ask = FALSE,force = TRUE)
})

cat(sprintf("%s正在使用install_github安装goldmine, handy. %s\n", blue, nc))
install_github("jeffbhasin/goldmine")
install_github("jeffbhasin/handy")

# 加载所有安装成功的程序包
for (prog in union(Rprograms, c(RprogramsNeedsBioc, "goldmine", "handy"))) {
  cat(sprintf("%s正在加载程序包: %s...\n",nc ,prog))
  
  # 使用 tryCatch 捕捉加载过程中的错误和警告
  load_result <- tryCatch({
    library(prog, character.only = TRUE)
    0  # 成功时返回0
  }, warning = function(w) {
    cat(sprintf("%s警告: %s%s\n", "\033[33m", w, "\033[0m"))  # 黄色表示警告
    0  # 警告时返回0
  }, error = function(e) {
    cat(sprintf("%s错误: 无法加载程序包 %s。%s\n", "\033[31m", prog, "\033[0m"))  # 红色表示错误
    1  # 错误时返回1
  })
  
  # 根据加载结果输出相应信息
  if (load_result == 0) {
    cat(sprintf("%s程序包 %s 加载成功。\n", green, prog))
  } 
}