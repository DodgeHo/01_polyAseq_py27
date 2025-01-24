# Download APA reproducible package

```
git clone https://github.com/DodgeHo/01_polyAseq_py27.git
cd 01_polyAseq_py27 # 进入代码文件夹
```

# Prerequisite

0. 安装python27, conda与pip2（如果尚未安装）：
   使用python2.7运行本软件:
   # 请注意，sudo 可能需要输入密码
   ```
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


1. 使用安装脚本安装其他项
   # 先确保自己位于子文件夹01_polyAseq_py27
   ```bash
   # 必须要先赋予执行权限再运行
   chmod +x 00_setup_polyaseq.sh
   bash ./00_setup_polyaseq.sh
   ```

# PolyA-seq data processing

2. 现在我们可以开始运行脚本了
   
   ```bash
   bash ./01_resource_prep.sh
   ```

3. 运行脚本2下载 PolyA-seq FASTQ 文件.  
   
   ```
   bash ./02_get_fastq.sh
   ```
   
   Note that, as of 05/21/2019, the SRAs, 
   - SRP083252 (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE86178)

   - SRP083254 (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE86180) 
   
   is not public. Secure tokens are available only reviewers to access processed data. Any raw data is not available yet until it becomes public.
  
  如果不希望全部下载，可以打开02_get_fastq.sh修改。在其中找到一行
  
  ```
   #srrs=(SRR4091084 SRR4091085 SRR4091086 SRR4091087 SRR4091088 SRR4091089 SRR4091090 SRR4091091 SRR4091104 SRR4091105 SRR4091106 SRR4091107 SRR4091108 SRR4091109 SRR4091110 SRR4091111 SRR4091113 SRR4091115 SRR4091117 SRR4091119)
    #修改为
    srrs=(SRR4091084)
  ```
4. 现在，可以执行polyA-seq processing pipeline（脚本3）了
    
    ```
    bash ./03_polyaseq.sh
    ```

5. Transcription factor binding analysis in the genomic regions in between polyA sites at each 546 APA gene
    
    ```
    Rscript ./04_enrich_perms_100k_select.r
    ```

```
6. Plot sequence logos for the highly enriched TFs
```

 Rscript ./05_plot_seqlogos.r

```
