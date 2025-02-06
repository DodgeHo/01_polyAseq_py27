# 脚本名称：00_setup_polyaseq.sh
# 功能：设置 Conda 环境、安装 Python/R 扩展包、配置环境变量、修改配置文件路径

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查输入参数
START_STEP=${1:-0}

# 提示信息
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Bioinfo 环境设置脚本${NC}"
echo -e "${NC}  本脚本调用方法为 00_setup_polyaseq.sh [起始步骤]${NC}"
echo -e "${NC}  例如：${YELLOW} bash ./00_setup_polyaseq.sh 4 ${NC} 将从第4步开始安装${NC}"
echo -e "${BLUE}  本脚本将完成以下操作：${NC}"
echo -e "${BLUE}  0. 创建conda环境polya27"
echo -e "${BLUE}  1. 安装 conda 扩展包${NC}"
echo -e "${BLUE}  2. 安装 pip 扩展包${NC}"
echo -e "${BLUE}  3. 安装 R 语言和扩展包${NC}"
echo -e "${BLUE}  4. 安装其他程序${NC}"
echo -e "${BLUE}  5. 配置环境变量${NC}"
echo -e "${BLUE}  6. 修改项目配置文件路径${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "${YELLOW}本脚本将从第${START_STEP}步开始安装${NC}"
echo ""

if [ $START_STEP -le 0 ]; then
    echo -e "${YELLOW}=== 0. 创建conda环境polya27 ===${NC}"

    # 删除已存在的同名环境
    if conda env remove -n polya27 -y; then
        echo -e "${GREEN}已删除同名环境polya27。${NC}"
    else
        echo -e "${YELLOW}未找到同名环境polya27，继续执行。${NC}"
    fi
    # 创建新的conda环境
    if conda create -n polya27 python=2.7 -y; then
        echo -e "${GREEN}conda环境polya27创建成功。${NC}"
    else
        echo -e "${RED}conda环境polya27创建失败。${NC}"
        exit 1
    fi

    # 初始化Conda，激活conda环境
    eval "$(conda shell.bash hook)"
    if conda activate polya27; then
        echo -e "${GREEN}conda环境polya27激活成功。${NC}"
    else
        echo -e "${RED}conda环境polya27激活失败。${NC}"
        exit 1
    fi
    # 验证python版本
    python --version

    # 添加conda-forge和bioconda频道
    conda config --add channels conda-forge
    conda config --add channels bioconda
    echo -e "${GREEN}conda-forge和bioconda频道已添加。${NC}"
fi

if [ $START_STEP -le 1 ]; then
    # 1. 安装 Conda 扩展包
    echo -e "${YELLOW}=== 1. 安装 Conda 扩展包 ===${NC}"
    echo -e "${BLUE}正在安装所有 Conda 包( mosdepth sra-tools star xz samtools bowtie2 regex biopython pysam pyfaidx argpars r-base)...${NC}"

    conda install -c bioconda -c conda-forge \
        mosdepth sra-tools star xz \
        samtools bowtie2 regex biopython \
        pysam pyfaidx argparse -y

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}所有 Conda 包( mosdepth sra-tools star xz samtools bowtie2 regex biopython pysam pyfaidx argpars r-base)安装成功。${NC}"
    else
        echo -e "${RED}安装失败，请检查 Conda 配置或依赖冲突。${NC}"
        exit 1
    fi
fi

if [ $START_STEP -le 2 ]; then
    # 2. 安装 PIP 扩展包
    echo -e "${YELLOW}=== 2. 安装 PIP 扩展包 ===${NC}"

    PIPprograms=(
        "wget" "configparser" "numpy" "pandas" 
    )

    for prog in "${PIPprograms[@]}"; do
        echo -e "${BLUE}正在安装 $prog...${NC}"
        pip install "$prog"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}$prog 安装成功。${NC}"
        else
            echo -e "${RED}$prog 安装失败，请检查网络或pip依赖。${NC}"
        fi
    done
fi

if [ $START_STEP -le 3 ]; then
    # 3. 安装 R 语言及扩展包
    echo -e "${YELLOW}=== 3. 安装 R 语言 ===${NC}"
    conda install -c bioconda -c r -c conda-forge r-base=4.4.2 -y
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}R 语言安装成功。${NC}"
    else
        echo -e "${RED}R 语言安装失败，请检查 Conda 配置。${NC}"
        exit 1
    fi

    echo -e "${BLUE}正在安装 R 包...${NC}"
    Rscript -e "source('003_setup_r_packages.r')"

fi

if [ $START_STEP -le 4 ]; then
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
fi

if [ $START_STEP -le 5 ]; then
    # 5. 配置环境变量
    echo -e "${YELLOW}=== 5. 配置环境变量 ===${NC}"

    SCRIPT_DIR=$(dirname "$0")
    PROJECT_ROOT=$(realpath "$SCRIPT_DIR")

    echo -e "${BLUE}项目根目录: $PROJECT_ROOT${NC}"
    export R_UTIL_APA="$PROJECT_ROOT/resource/libs"
    export PADD_GIT="$PROJECT_ROOT/paddle-git"

    echo -e "${BLUE}正在将环境变量写入 ~/.bashrc...${NC}"
    echo "export R_UTIL_APA=$R_UTIL_APA" >> ~/.bashrc
    echo "export PADD_GIT=$PADD_GIT" >> ~/.bashrc
    source ~/.bashrc
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}环境变量配置成功。${NC}"
    else
        echo -e "${RED}环境变量配置失败，请检查 ~/.bashrc 文件权限。${NC}"
    fi
fi

if [ $START_STEP -le 6 ]; then
    # 6. 修改配置文件路径
    echo -e "${YELLOW}=== 6. 修改配置文件路径 ===${NC}"

    CONFIG_FILE="$PROJECT_ROOT/configs/program.conf"
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
fi

echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}  环境设置完成！请运行以下命令激活环境：${NC}"
echo -e "${GREEN}  conda activate polya27${NC}"
echo -e "${BLUE}============================================${NC}"
