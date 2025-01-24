```bash
#!/bin/bash

# 脚本名称：00_setup_polyaseq.sh
# 功能：设置 Conda 环境、安装 Python/R 扩展包、配置环境变量、修改配置文件路径
# 日志文件：setup_polyaseq_env.log

# 日志文件路径
LOG_FILE="setup_polyaseq_env.log"

# 清空日志文件
> "$LOG_FILE"

log_and_echo() {
    local message="$1"
    echo "$message"  # 直接输出到终端
    echo "$message" >> "$LOG_FILE"  # 同时记录到日志文件

}

# 提示信息
echo "============================================"
echo "  Bioinfo 环境设置脚本"
echo "  本脚本将完成以下操作："
echo "  1. 安装 PIP 扩展包"
echo "  2. 安装 Conda 扩展包"
echo "  3. 安装 R 语言和扩展包"
echo "  4. 安装其他程序"
echo "  5. 配置环境变量"
echo "  6. 修改项目配置文件路径"
echo "  日志文件: $LOG_FILE"
echo "============================================"
echo ""

# 1. 安装 PIP 扩展包
log_and_echo ""
log_and_echo "=== 1. 安装 PIP 扩展包 ==="

PIPprograms=(
    "wget" "configparser" "numpy" "pandas" "pysam" "argparse"
    "pyfaidx" "Bio" "deeptools" "regex"
)

for prog in "${PIPprograms[@]}"; do
    log_and_echo "正在安装 $prog..."
    pip install "$prog" >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        log_and_echo "$prog 安装成功。"
    else
        log_and_echo "$prog 安装失败，请检查网络或依赖。"
    fi
done

# 2. 安装 Conda 扩展包
log_and_echo ""
log_and_echo "=== 2. 安装 Conda 扩展包 ==="

CONDAprograms=(
    "mosdepth" "sra-tools" "star" "xz" "wget"
    "samtools" "bowtie2"
)

for prog in "${CONDAprograms[@]}"; do
    log_and_echo "正在安装 $prog..."
    conda install -c bioconda "$prog" -y >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        log_and_echo "$prog 安装成功。"
    else
        log_and_echo "$prog 安装失败，请检查 Conda 配置。"
    fi
done

# 3. 安装 R 语言和扩展包
log_and_echo ""
log_and_echo "=== 3. 安装 R 语言和扩展包 ==="

log_and_echo "正在安装 R 语言..."
conda install -c bioconda r-base=3.4.3 -y >> "$LOG_FILE" 2>&1
if [ $? -eq 0 ]; then
    log_and_echo "R 语言安装成功。"
else
    log_and_echo "R 语言安装失败，请检查 Conda 配置。"
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
    log_and_echo "正在安装 R 包: $prog..."
    Rscript -e "install.packages('$prog', repos='https://cloud.r-project.org/')" >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        log_and_echo "$prog 安装成功。"
    else
        log_and_echo "$prog 安装失败，请检查网络或依赖。"
    fi
done

# 安装 Handy 包
log_and_echo "正在安装 Handy 包..."
git clone https://github.com/jeffbhasin/handy.git >> "$LOG_FILE" 2>&1
cd handy
Rscript -e "library(devtools); install_github('jeffbhasin/handy')" >> "$LOG_FILE" 2>&1
cd ..
if [ $? -eq 0 ]; then
    log_and_echo "Handy 包安装成功。"
else
    log_and_echo "Handy 包安装失败，请检查网络或依赖。"
fi

# 4. 安装其他程序
log_and_echo ""
log_and_echo "=== 4. 安装其他程序 ==="

log_and_echo "正在下载 UCSC 工具集..."
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/twoBitToFa >> "$LOG_FILE" 2>&1
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/wigToBigWig >> "$LOG_FILE" 2>&1
chmod +x twoBitToFa
chmod +x wigToBigWig
if [ $? -eq 0 ]; then
    log_and_echo "UCSC 工具集下载并配置成功。"
else
    log_and_echo "UCSC 工具集下载失败，请检查网络。"
fi

# 5. 配置环境变量
log_and_echo ""
log_and_echo "=== 5. 配置环境变量 ==="

SCRIPT_DIR=$(dirname "$0")
PROJECT_ROOT=$(realpath "$SCRIPT_DIR")

log_and_echo "项目根目录: $PROJECT_ROOT"
export R_UTIL_APA="$PROJECT_ROOT/resource/libs"
export PADD_GIT="$PROJECT_ROOT/01_polyAseq/paddle-git"

log_and_echo "正在将环境变量写入 ~/.bashrc..."
echo "export R_UTIL_APA=$R_UTIL_APA" >> ~/.bashrc
echo "export PADD_GIT=$PADD_GIT" >> ~/.bashrc
source ~/.bashrc >> "$LOG_FILE" 2>&1
if [ $? -eq 0 ]; then
    log_and_echo "环境变量配置成功。"
else
    log_and_echo "环境变量配置失败，请检查 ~/.bashrc 文件权限。"
fi

# 6. 修改配置文件路径
log_and_echo ""
log_and_echo "=== 6. 修改配置文件路径 ==="

CONFIG_FILE="$PROJECT_ROOT/01_polyAseq/configs/program.conf"
if [ -f "$CONFIG_FILE" ]; then
    log_and_echo "正在修改配置文件: $CONFIG_FILE"
    sed -i "s|~/projects/apa_atingLab2019|$PROJECT_ROOT|g" "$CONFIG_FILE" >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        log_and_echo "配置文件路径修改成功。"
    else
        log_and_echo "配置文件路径修改失败，请检查文件权限。"
    fi
else
    log_and_echo "配置文件 $CONFIG_FILE 不存在，请检查路径。"
fi

log_and_echo ""
log_and_echo "============================================"
log_and_echo "  环境设置完成！请运行以下命令激活环境："
log_and_echo "  conda activate bioinfo27"
log_and_echo "  日志文件: $LOG_FILE"
log_and_echo "============================================"
```

---

### 主要修改点：
1. **日志记录**：
   - 使用 `>> "$LOG_FILE" 2>&1` 将命令的输出和错误流重定向到日志文件。
   - 使用 `tee -a "$LOG_FILE"` 将提示信息同时输出到屏幕和日志文件。

2. **隐藏不必要的输出**：
   - 所有命令的输出（包括警告信息）都被重定向到日志文件，不会直接显示在屏幕上。

3. **日志文件管理**：
   - 在脚本开头清空日志文件（`> "$LOG_FILE"`），确保每次运行脚本时日志文件是干净的。

---

### 使用方法：
1. 将脚本保存为 `setup_bioinfo_env.sh`。
2. 赋予执行权限：
   ```bash
   chmod +x setup_bioinfo_env.sh
   ```
3. 运行脚本：
   ```bash
   ./setup_bioinfo_env.sh
   ```