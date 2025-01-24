#!/bin/bash

# 脚本名称：00_setup_polyaseq.sh
# 功能：设置 Conda 环境、安装 Python/R 扩展包、配置环境变量、修改配置文件路径

# 提示信息
echo "============================================"
echo "  Bioinfo 环境设置脚本"
echo "  本脚本将完成以下操作："
echo "  1. 创建或更新 Conda 环境（bioinfo27）"
echo "  2. 安装 Python 和 R 的扩展包"
echo "  3. 配置环境变量"
echo "  4. 修改项目配置文件路径"
echo "============================================"
echo ""

# 1. 设置 Conda 环境
echo "=== 1. 设置 Conda 环境 ==="

# 检查环境是否存在
if conda env list | grep -q "bioinfo27"; then
    echo "环境 'bioinfo27' 已存在，正在删除..."
    conda env remove -n bioinfo27
    echo "环境 'bioinfo27' 已删除。"
else
    echo "环境 'bioinfo27' 不存在。"
fi

# 创建新的环境
echo "正在创建环境 'bioinfo27'..."
conda create -n bioinfo27 python=2.7 -y
if [ $? -eq 0 ]; then
    echo "环境 'bioinfo27' 创建成功。"
else
    echo "环境创建失败，请检查 Conda 是否安装正确。"
    exit 1
fi

# 激活环境
echo "激活环境 'bioinfo27'..."
conda activate bioinfo27
if [ $? -ne 0 ]; then
    echo "环境激活失败，请检查 Conda 是否配置正确。"
    exit 1
fi

# 2. 安装 Python 扩展包
echo ""
echo "=== 2. 安装 Python 扩展包 ==="

PIPprograms=(
    "wget" "configparser" "numpy" "pandas" "pysam" "argparse"
    "pyfaidx" "Bio" "deeptools" "regex"
)

for prog in "${PIPprograms[@]}"; do
    echo "正在安装 $prog..."
    pip install "$prog"
    if [ $? -eq 0 ]; then
        echo "$prog 安装成功。"
    else
        echo "$prog 安装失败，请检查网络或依赖。"
    fi
done

# 3. 安装 Conda 扩展包
echo ""
echo "=== 3. 安装 Conda 扩展包 ==="

CONDAprograms=(
    "mosdepth" "sra-tools" "star" "xz" "wget"
    "samtools" "bowtie2"
)

for prog in "${CONDAprograms[@]}"; do
    echo "正在安装 $prog..."
    conda install -c bioconda "$prog" -y
    if [ $? -eq 0 ]; then
        echo "$prog 安装成功。"
    else
        echo "$prog 安装失败，请检查 Conda 配置。"
    fi
done

# 4. 安装 R 语言和扩展包
echo ""
echo "=== 4. 安装 R 语言和扩展包 ==="

echo "正在安装 R 语言..."
conda install -c bioconda r-base=3.4.3 -y
if [ $? -eq 0 ]; then
    echo "R 语言安装成功。"
else
    echo "R 语言安装失败，请检查 Conda 配置。"
    exit 1
fi

Rprograms=(
    "goldmine" "argparse" "BSgenome.Hsapiens.UCSC.hg19" "corrplot"
    "data.table" "DEXSeq" "e1071" "edgeR" "ggbio" "ggplot2" "gridExtra"
    "IlluminaHumanMethylation450kanno.ilmn12.hg19" "matrixStats" "openxlsx"
    "parallel" "reshape" "RPMM" "Rsamtools" "Rsubread" "stringr" "ggseqlogo"
    "JASPAR2018" "TFBSTools" "UpSetR" "VennDiagram" "wateRmelon" "devtools"
)

for prog in "${Rprograms[@]}"; do
    echo "正在安装 R 包: $prog..."
    Rscript -e "install.packages('$prog', repos='https://cloud.r-project.org/')"
    if [ $? -eq 0 ]; then
        echo "$prog 安装成功。"
    else
        echo "$prog 安装失败，请检查网络或依赖。"
    fi
done

# 安装 Handy 包
echo "正在安装 Handy 包..."
git clone https://github.com/jeffbhasin/handy.git
cd handy
Rscript -e "library(devtools); install_github('jeffbhasin/handy')"
cd ..
if [ $? -eq 0 ]; then
    echo "Handy 包安装成功。"
else
    echo "Handy 包安装失败，请检查网络或依赖。"
fi

# 5. 安装其他程序
echo ""
echo "=== 5. 安装其他程序 ==="

echo "正在下载 UCSC 工具集..."
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/twoBitToFa
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/wigToBigWig
chmod +x twoBitToFa
chmod +x wigToBigWig
if [ $? -eq 0 ]; then
    echo "UCSC 工具集下载并配置成功。"
else
    echo "UCSC 工具集下载失败，请检查网络。"
fi

# 6. 配置环境变量
echo ""
echo "=== 6. 配置环境变量 ==="

SCRIPT_DIR=$(dirname "$0")
PROJECT_ROOT=$(realpath "$SCRIPT_DIR")

echo "项目根目录: $PROJECT_ROOT"
export R_UTIL_APA="$PROJECT_ROOT/resource/libs"
export PADD_GIT="$PROJECT_ROOT/01_polyAseq/paddle-git"

echo "正在将环境变量写入 ~/.bashrc..."
echo "export R_UTIL_APA=$R_UTIL_APA" >> ~/.bashrc
echo "export PADD_GIT=$PADD_GIT" >> ~/.bashrc
source ~/.bashrc
if [ $? -eq 0 ]; then
    echo "环境变量配置成功。"
else
    echo "环境变量配置失败，请检查 ~/.bashrc 文件权限。"
fi

# 7. 修改配置文件路径
echo ""
echo "=== 7. 修改配置文件路径 ==="

CONFIG_FILE="$PROJECT_ROOT/configs/program.conf"
if [ -f "$CONFIG_FILE" ]; then
    echo "正在修改配置文件: $CONFIG_FILE"
    sed -i "s|~/projects/apa_atingLab2019|$PROJECT_ROOT|g" "$CONFIG_FILE"
    if [ $? -eq 0 ]; then
        echo "配置文件路径修改成功。"
    else
        echo "配置文件路径修改失败，请检查文件权限。"
    fi
else
    echo "配置文件 $CONFIG_FILE 不存在，请检查路径。"
fi

echo ""
echo "============================================"
echo "  环境设置完成！请运行以下命令激活环境："
echo "  conda activate bioinfo27"
echo "============================================"























