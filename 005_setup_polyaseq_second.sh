# 脚本名称：005_setup_polyaseq_second.sh
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
echo -e "${BLUE}  4. 安装其他程序${NC}"
echo -e "${BLUE}  5. 配置环境变量${NC}"
echo -e "${BLUE}  6. 修改项目配置文件路径${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

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

echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}  环境设置完成！请运行以下命令激活环境：${NC}"
echo -e "${GREEN}  conda activate polya27${NC}"
echo -e "${BLUE}============================================${NC}"
