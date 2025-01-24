# 脚本名称：00_setup_polyaseq.sh
# 功能：设置 Conda 环境、安装 Python/R 扩展包、配置环境变量、修改配置文件路径

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 提示信息
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Bioinfo 环境设置脚本${NC}"
echo -e "${BLUE}  本脚本将完成以下操作：${NC}"
echo -e "${BLUE}  1. 安装 PIP 扩展包${NC}"
echo -e "${BLUE}  2. 安装 Conda 扩展包${NC}"
echo -e "${BLUE}  3. 安装 R 语言和扩展包${NC}"
echo -e "${BLUE}  4. 安装其他程序${NC}"
echo -e "${BLUE}  5. 配置环境变量${NC}"
echo -e "${BLUE}  6. 修改项目配置文件路径${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# 1. 安装 PIP 扩展包
echo -e "${YELLOW}=== 1. 安装 PIP 扩展包 ===${NC}"

PIPprograms=(
    "wget" "configparser" "numpy" "pandas" "pysam" "argparse"
    "pyfaidx" "Bio" "deeptools" "regex"
)

for prog in "${PIPprograms[@]}"; do
    echo -e "${BLUE}正在安装 $prog...${NC}"
    pip install "$prog"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}$prog 安装成功。${NC}"
    else
        echo -e "${RED}$prog 安装失败，请检查网络或依赖。${NC}"
    fi
done

# 2. 安装 Conda 扩展包
echo -e "${YELLOW}=== 2. 安装 Conda 扩展包 ===${NC}"

CONDAprograms=(
    "mosdepth" "sra-tools" "star" "xz" "wget"
    "samtools" "bowtie2"
)

for prog in "${CONDAprograms[@]}"; do
    echo -e "${BLUE}正在安装 $prog...${NC}"
    conda install -c bioconda "$prog" -y
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}$prog 安装成功。${NC}"
    else
        echo -e "${RED}$prog 安装失败，请检查 Conda 配置。${NC}"
    fi
done

# 3. 安装 R 语言和扩展包
echo -e "${YELLOW}=== 3. 安装 R 语言和扩展包 ===${NC}"

echo -e "${BLUE}正在安装 R 语言...${NC}"
conda install -c bioconda r-base=3.4.3 -y
if [ $? -eq 0 ]; then
    echo -e "${GREEN}R 语言安装成功。${NC}"
else
    echo -e "${RED}R 语言安装失败，请检查 Conda 配置。${NC}"
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
    echo -e "${BLUE}正在安装 R 包: $prog...${NC}"
    Rscript -e "install.packages('$prog', repos='https://cloud.r-project.org/')"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}$prog 安装成功。${NC}"
    else
        echo -e "${RED}$prog 安装失败，请检查网络或依赖。${NC}"
    fi
done

# 安装 Handy 包
echo -e "${BLUE}正在安装 Handy 包...${NC}"
git clone https://github.com/jeffbhasin/handy.git
cd handy
Rscript -e "library(devtools); install_github('jeffbhasin/handy')"
cd ..
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Handy 包安装成功。${NC}"
else
    echo -e "${RED}Handy 包安装失败，请检查网络或依赖。${NC}"
fi

# 4. 安装其他程序
echo -e "${YELLOW}=== 4. 安装其他程序 ===${NC}"

echo -e "${BLUE}正在下载 UCSC 工具集...${NC}"
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/twoBitToFa
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/wigToBigWig
chmod +x twoBitToFa
chmod +x wigToBigWig
if [ $? -eq 0 ]; then
    echo -e "${GREEN}UCSC 工具集下载并配置成功。${NC}"
else
    echo -e "${RED}UCSC 工具集下载失败，请检查网络。${NC}"
fi

# 5. 配置环境变量
echo -e "${YELLOW}=== 5. 配置环境变量 ===${NC}"

SCRIPT_DIR=$(dirname "$0")
PROJECT_ROOT=$(realpath "$SCRIPT_DIR")

echo -e "${BLUE}项目根目录: $PROJECT_ROOT${NC}"
export R_UTIL_APA="$PROJECT_ROOT/resource/libs"
export PADD_GIT="$PROJECT_ROOT/01_polyAseq/paddle-git"

echo -e "${BLUE}正在将环境变量写入 ~/.bashrc...${NC}"
echo "export R_UTIL_APA=$R_UTIL_APA" >> ~/.bashrc
echo "export PADD_GIT=$PADD_GIT" >> ~/.bashrc
source ~/.bashrc
if [ $? -eq 0 ]; then
    echo -e "${GREEN}环境变量配置成功。${NC}"
else
    echo -e "${RED}环境变量配置失败，请检查 ~/.bashrc 文件权限。${NC}"
fi

# 6. 修改配置文件路径
echo -e "${YELLOW}=== 6. 修改配置文件路径 ===${NC}"

CONFIG_FILE="$PROJECT_ROOT/01_polyAseq/configs/program.conf"
if [ -f "$CONFIG_FILE" ]; then
    echo -e "${BLUE}正在修改配置文件: $CONFIG_FILE${NC}"
    sed -i "s|~/projects/apa_atingLab2019|$PROJECT_ROOT|g" "$CONFIG_FILE"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}配置文件路径修改成功。${NC}"
    else
        echo -e "${RED}配置文件路径修改失败，请检查文件权限。${NC}"
    fi
else
    echo -e "${RED}配置文件 $CONFIG_FILE 不存在，请检查路径。${NC}"
fi

echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}  环境设置完成！请运行以下命令激活环境：${NC}"
echo -e "${GREEN}  conda activate bioinfo27${NC}"
echo -e "${BLUE}============================================${NC}"
