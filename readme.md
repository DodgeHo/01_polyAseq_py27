# Download APA Reproducible Package

```bash
git clone https://github.com/DodgeHo/01_polyAseq_py27.git
cd 01_polyAseq_py27 # 进入代码文件夹
```

# Prerequisite

## 0. 安装 Python 2.7、Conda 与 pip2（如果尚未安装）

使用 Python 2.7 运行本软件：

```bash
# 下载 Miniconda（Python 2.7 版本）
wget https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh

# 赋予执行权限
chmod +x Miniconda2-latest-Linux-x86_64.sh

# 安装 Miniconda
./Miniconda2-latest-Linux-x86_64.sh -b -f -p /usr/local

# 安装 Python 2.7（如果尚未安装）
sudo apt install python2

# 安装 pip for Python 2.7
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
```

## 1. 使用安装脚本安装其他依赖项

确保当前位于 `01_polyAseq_py27` 文件夹中：

```bash
# 赋予执行权限并运行安装脚本
chmod +x 00_setup_polyaseq.sh
bash ./00_setup_polyaseq.sh
```

# PolyA-seq Data Processing

## 2. 运行脚本 1 准备资源

```bash
bash ./01_resource_prep.sh
```

## 3. 运行脚本 2 下载 PolyA-seq FASTQ 文件

```bash
bash ./02_get_fastq.sh
```

**注意**：截至 2019 年 5 月 21 日，以下 SRA 数据尚未公开：
- SRP083252 ([GSE86178](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE86178))
- SRP083254 ([GSE86180](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE86180))

只有审稿人可以通过安全令牌访问处理后的数据。原始数据在公开之前不可用。

如果不希望下载全部数据，可以编辑 `02_get_fastq.sh` 文件，修改以下行：

```bash
# 原始行
# srrs=(SRR4091084 SRR4091085 SRR4091086 SRR4091087 SRR4091088 SRR4091089 SRR4091090 SRR4091091 SRR4091104 SRR4091105 SRR4091106 SRR4091107 SRR4091108 SRR4091109 SRR4091110 SRR4091111 SRR4091113 SRR4091115 SRR4091117 SRR4091119)

# 修改为
srrs=(SRR4091084)
```

## 4. 运行 PolyA-seq 处理流程（脚本 3）

```bash
bash ./03_polyaseq.sh
```

## 5. 转录因子结合分析

在 polyA 位点之间的基因组区域进行转录因子结合分析：

```bash
Rscript ./04_enrich_perms_100k_select.r
```

## 6. 绘制高度富集的转录因子的序列标识图

```bash
Rscript ./05_plot_seqlogos.r
```

