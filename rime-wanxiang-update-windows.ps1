#����Ŀ��ַ�� https://github.com/rimeinn/rime-wanxiang-update-tools
# ======= �����в������壬������ڽű���� =======
param(
    [string]$schemaType,
    [string]$cliTargetFolder,
    [switch]$noSchema,
    [switch]$noDict,
    [switch]$noModel,
    [switch]$disableCNB,
    [switch]$disableAutoReDeploy,
    [switch]$auto,
    [switch]$useCurl,
    [string]$skipFiles,
    [switch]$help,
    [switch]$debug
)

function Exit-Tip {
    param(
        [string]$exitCode = 0
    )
    Write-Host '��������˳�...'
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit $exitCode
}

if ($auto -and (-not $schemaType -or $schemaType -notmatch '^[0-6]$')) {
    Write-Host "�����Զ�ģʽ�±���ͨ�� -schemaType ָ���������ͱ�ţ�0-6������ -schemaType 6" -ForegroundColor Red
    Exit-Tip 1
}

if ($help -or $args -contains '-h' -or $args -contains '--help') {
    # ���ڷ� help ģʽ��ǿ��Ҫ�� schemaType
    if (-not $help -and -not ($args -contains '-h') -and -not ($args -contains '--help')) {
        if (-not $schemaType) {
            Write-Host "����-schemaType ����Ϊ�������ָ���������ͱ�ţ�0-6����" -ForegroundColor Red
            Write-Host "ʾ����pwsh -File .\\�����������󷽰�-�ʿ�-ģ��-utf-8.ps1 -schemaType 6"
            Exit-Tip 1
        }
    }
    Write-Host "Rime ���� PowerShell ���¹��� - �����в���˵��" -ForegroundColor Cyan
    Write-Host "---------------------------------------------"
    Write-Host "-schemaType <���>   �������ͱ�ţ�0-6 (�� 6 ��ʾ��Ȼ��)"
    Write-Host "-noSchema            �����·���"
    Write-Host "-noDict              �����´ʿ�"
    Write-Host "-noModel             ������ģ��"
    Write-Host "-cliTargetFolder <·��>  ָ��Ŀ�갲װĿ¼��������ע����ȡ������ṩ������·�������Ժ�дȨ�޽��м�飩"
    Write-Host "-auto                �����Զ�����ģʽ"
    Write-Host "-debug               ���õ���ģʽ(������������Ϣ)"
    Write-Host "-useCurl             ʹ��curl.exe���������ٶȲ������ж�"
    Write-Host "-disableCNB          ��ʹ�� CNB ����Դ"
    Write-Host "-disableAutoReDeploy ���Զ��������²���"
    Write-Host "-skipFiles <�ļ�1,�ļ�2,...>  ����ָ���ļ������ŷָ�"
    Write-Host "-h, --help           ��ʾ��������Ϣ"
    Write-Host "ʾ����"
    Write-Host "pwsh -ExecutionPolicy Bypass -File .\\�����������󷽰�-�ʿ�-ģ��-utf-8.ps1 -schemaType 6 -auto -noModel"
    Write-Host "pwsh -File .\\�����������󷽰�-�ʿ�-ģ��-utf-8.ps1 -schemaType 1 -skipFiles 'wanxiang_en.dict.yaml,tone_fallback.lua'"
    Exit-Tip 0
}

############# �Զ�������������úú� AutoUpdate ����Ϊ true ���� #############
$AutoUpdate = $false;

# �Ƿ�ʹ�� CNB ����Դ���������Ϊ $true����� CNB ��ȡ��Դ������� GitHub ��ȡ��
$UseCnbMirrorSource = $true

# �Ƿ�ʹ�� curl.exe ���� Invoke-WebRequest�����������ٶȣ������������ж�
$UseCurl = $false

# �����Զ�����ʱ���Ƿ���·������ʿ⡢ģ�ͣ��������ĳ��͸ĳ�false
$IsUpdateSchemaDown = $true
$IsUpdateDictDown = $true
$IsUpdateModel = $true

# �����Զ�����ʱѡ��ķ�����ע��������˫���ţ����磺$InputSchemaType = "0";
# [0]-��׼��; [1]-С��; [2]-����; [3]-ī��; [4]-����; [5]-���; [6]-��Ȼ��"
$InputSchemaType = "6";

# �����Զ�����ʱҪ�������ļ��б����úú�ɾ��ע�ͷ���
# $SkipFiles = @(
#     "wanxiang_symbols.yaml",
#     "weasel.yaml",
#     "others.txt"
# );

# ���ô����ַ�Ͷ˿ڣ����úú�ɾ��ע�ͷ���
# $proxyAddress = "http://127.0.0.1:7897"
# [System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy($proxyAddress)
# [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

# ����GitHub Token����ͷ����ֹapi����ʧ��403�������úú�ɾ��ע�ͷ���
# $env:GITHUB_TOKEN = "�����������token�ַ���"    #������https://github.com/settings/tokens��ע��һ��token# (Public repositories) 

############# �Զ�������������úú� AutoUpdate ����Ϊ true ���� #############

$Debug = $false;

# ֧�������в������ǹؼ�ѡ��
# ͨ�������в�����������
if ($PSBoundParameters.ContainsKey('schemaType')) {
    $InputSchemaType = $schemaType
}
if ($PSBoundParameters.ContainsKey('auto')) {
    $AutoUpdate = $true
}
if ($PSBoundParameters.ContainsKey('disableCNB')) {
    $UseCnbMirrorSource = $false
}
if ($PSBoundParameters.ContainsKey('useCurl')) {
    $UseCurl = $true
}
if ($PSBoundParameters.ContainsKey('noSchema')) {
    $IsUpdateSchemaDown = $false
}
if ($PSBoundParameters.ContainsKey('noDict')) {
    $IsUpdateDictDown = $false
}
if ($PSBoundParameters.ContainsKey('noModel')) {
    $IsUpdateModel = $false
}
if ($PSBoundParameters.ContainsKey('debug')) {
    Write-Host "���� debug ģʽ"
    $Debug = $true
}
if ($PSBoundParameters.ContainsKey('skipFiles')) {
    Write-Host "���¸�ֵ SkipFiles"
    # ֧���Զ��Ż�����հ׷ָ��Ķ������룬����:
    # -skipFiles 'a.txt,b.txt' �� -skipFiles 'a.txt b.txt' �� -skipFiles 'a.txt, b.txt'
    if ($skipFiles -is [string]) {
        $items = $skipFiles -split '[,\s]+'
    } else {
        $items = $skipFiles
    }
    # ȥ��������˿հײ�ȥ��
    $SkipFiles = $items | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' } | Select-Object -Unique
    Write-Host "���� SkipFiles ���ݣ�" $SkipFiles
}
# ����������ṩ�� cliTargetFolder ������������ʹ�ò���֤
if ($PSBoundParameters.ContainsKey('cliTargetFolder') -and $cliTargetFolder) {
    try {
        $resolvedPath = Resolve-Path -Path $cliTargetFolder -ErrorAction Stop
        $resolvedPath = $resolvedPath.ProviderPath
    }
    catch {
        Write-Host "����ָ����Ŀ���ļ��в����ڣ� $cliTargetFolder" -ForegroundColor Red
        Exit-Tip 1
    }

    if (-not (Test-Path $resolvedPath -PathType Container)) {
        Write-Host "����ָ��·������Ŀ¼�� $resolvedPath" -ForegroundColor Red
        Exit-Tip 1
    }

    # ���дȨ�ޣ����Դ�����ɾ����ʱ�ļ�
    try {
        $permTestFile = Join-Path $resolvedPath ".wanxiang_perm_test_$([System.Guid]::NewGuid().ToString()).tmp"
        New-Item -Path $permTestFile -ItemType File -Force -ErrorAction Stop | Out-Null
        Remove-Item -Path $permTestFile -Force -ErrorAction SilentlyContinue
    }
    catch {
        Write-Host "����û�ж�Ŀ��Ŀ¼��д��Ȩ�ޣ� $resolvedPath" -ForegroundColor Red
        Exit-Tip 1
    }
}

$UpdateToolsVersion = "v6.1.5";
if ($UpdateToolsVersion.StartsWith("DEFAULT")) {
    Write-Host "�����ص��ǷǷ��а�ű�������ֱ��ʹ�ã���ȥ releases ҳ���������°汾��https://github.com/rimeinn/rime-wanxiang-update-tools/releases" -ForegroundColor Yellow;
} else {
    Write-Host "��ǰ���¹��߰汾��$UpdateToolsVersion" -ForegroundColor Yellow;
}

# ���òֿ������ߺ�����
$UpdateToolsOwner = "rimeinn"
$UpdateToolsRepo = "rime-wanxiang-update-tools"
# ������ʱ�ļ�·����׼��������ʱ�ļ�·����ȷ�� $targetDir �����ã�
$BaseTempPath = [System.IO.Path]::GetTempPath()

$GramModelFileName = "wanxiang-lts-zh-hans.gram"
$ReleaseTimeRecordFile = "release_time_record.json"

if ($UseCnbMirrorSource) {
    $SchemaOwner = "amzxyz"
    $SchemaRepo = "rime-wanxiang"
    $GramRepo = "RIME-LMDG"
    $GramReleaseTag = "model"
    $DictReleaseTag = "v1.0.0"
} else {
    $SchemaOwner = "amzxyz"
    $SchemaRepo = "rime_wanxiang"
    $GramRepo = "RIME-LMDG"
    $GramReleaseTag = "LTS"
    $DictReleaseTag = "dict-nightly"
}

$KeyTable = @{
    "0" = "base";
    "1" = "flypy";
    "2" = "hanxin";
    "3" = "moqi";
    "4" = "tiger";
    "5" = "wubi";
    "6" = "zrm";
}

$UriHeader = @{
    "accept"="application/vnd.cnb.web+json"
    "cache-control"="no-cache"
    'Accept-Charset' = 'utf-8'
}

$SchemaDownloadTip = "[0]-��׼��; [1]-С��; [2]-����; [3]-ī��; [4]-����; [5]-���; [6]-��Ȼ��";

$GramKeyTable = @{
    "0" = "zh-hans.gram";
}

$GramFileTableIndex = 0;

$DictFileSaveDirTable = @{
    "base" = "dicts";
    "pro" = "dicts";
}

$DictFileSaveDirTableIndex = "base";

# ���ð�ȫЭ��ΪTLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ��ȡ Weasel �û�Ŀ¼·��
function Get-RegistryValue {
    param(
        [string]$regPath,
        [string]$regValue
    )
    
    try {
        # ��ȡע���ֵ
        $value = (Get-ItemProperty -Path $regPath -Name $regValue).$regValue
        # ���ؽ��
        return $value
    }
    catch {
        Write-Host "���棺ע���·�� $regPath �����ڣ��������뷨�Ƿ���ȷ��װ" -ForegroundColor Yellow
        return $null
    }
}

function Get-FileNameWithoutExtension {
    param(
        [string]$filePath
    )
    $fileName = Split-Path $filePath -Leaf
    return $fileName -replace '\.[^.]+$', ''
}

function Get-DictExtractedFolderPath {
    param(
        [string]$extractPath,
        [string]$assetName
    )
    $folders = Get-ChildItem -Path $extractPath -Directory
    if ($folders.Count -eq 0) {
        Write-Host "���󣺽�ѹ���Ŀ¼��û���ҵ��κ��ļ���" -ForegroundColor Red
        Exit-Tip 1
    } elseif ($folders.Count -gt 1) {
        Write-Host "���棺��ѹ���Ŀ¼���ж���ļ��У���ʹ�õ�һ���ļ���" -ForegroundColor Yellow
        Write-Host "�ļ�������: $($folders[0].Name)" -ForegroundColor Green
        return $folders[0].FullName
    } else {
        Write-Host "��ѹ���Ŀ¼��ֻ��һ���ļ��У���ʹ�ø��ļ���" -ForegroundColor Green
        Write-Host "�ļ�������: $($folders[0].Name)" -ForegroundColor Green
        return $folders[0].FullName
    }
}

function Get-WeaselUserDir {
    try {
        $userDir = Get-RegistryValue -regPath "HKCU:\Software\Rime\Weasel" -regValue "RimeUserDir"
        if (-not $userDir) {
            # appdata Ŀ¼�µ� Rime Ŀ¼
            $userDir = Join-Path $env:APPDATA "Rime"
        }
        return $userDir
    }
    catch {
        Write-Host "���棺δ�ҵ�Weasel�û�Ŀ¼����ȷ������ȷ��װС�Ǻ����뷨" -ForegroundColor Yellow
    }
}

function Get-WeaselInstallDir {
    try {
        return Get-RegistryValue -regPath "HKLM:\SOFTWARE\WOW6432Node\Rime\Weasel" -regValue "WeaselRoot"
    }
    catch {
        Write-Host "���棺δ�ҵ�Weasel��װĿ¼����ȷ������ȷ��װС�Ǻ����뷨" -ForegroundColor Yellow
        return $null
    }
}

function Get-WeaselServerExecutable {
    try {
        return Get-RegistryValue -regPath "HKLM:\SOFTWARE\WOW6432Node\Rime\Weasel" -regValue "ServerExecutable"
    }
    catch {
        Write-Host "���棺δ�ҵ�Weasel����˿�ִ�г�����ȷ������ȷ��װС�Ǻ����뷨" -ForegroundColor Yellow
        return $null
    }
}

function Test-SkipFile {
    param(
        [string]$filePath
    )
    # �淶������
    if (-not $filePath) { return $false }
    $fullPath = [System.IO.Path]::GetFullPath($filePath) 2>$null
    if (-not $fullPath) { $fullPath = $filePath }
    $baseName = Get-FileNameWithoutExtension($filePath)
    $fileName = Split-Path $filePath -Leaf

    if ($Debug) {
        Write-Host "Testing skip for file: $filePath" -ForegroundColor Cyan
        Write-Host "Full path: $fullPath" -ForegroundColor Cyan
        Write-Host "Base name: $baseName" -ForegroundColor Cyan
        Write-Host "File name: $fileName" -ForegroundColor Cyan
    }

    # ȷ�� $SkipFiles ������
    $skipList = @()
    if ($null -ne $SkipFiles) {
        if ($SkipFiles -is [string]) {
            $skipList = @($SkipFiles)
        } else {
            $skipList = $SkipFiles
        }
    }

    if ($Debug) {
        Write-Host "Debug: checking skip list items (count=$($skipList.Count))" -ForegroundColor Cyan
        $i = 0
        foreach ($item in $skipList) {
            if ($null -eq $item) { Write-Host "  [$i] <null>" -ForegroundColor Cyan }
            else { Write-Host "  [$i] '$item' (len=$($item.Length))" -ForegroundColor Cyan }
            $i++
        }
        Write-Host "Debug: fileName='$fileName' (len=$($fileName.Length)), baseName='$baseName' (len=$($baseName.Length)), fullPath='$fullPath'" -ForegroundColor Cyan
    }

    # ���ף���� skipList ����һ���Ҹ����ڲ����ո�򶺺ţ��������Ծɸ�ʽ�ĵ��ַ�������ֺ�ʹ��
    if ($skipList.Count -eq 1 -and $skipList[0] -match '[,\s]') {
        if ($Debug) { Write-Host "Debug: single skipList item contains separators, splitting into multiple items" -ForegroundColor Cyan }
        $splitItems = $skipList[0] -split '[,\s]+' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' } | Select-Object -Unique
        $skipList = $splitItems
        if ($Debug) { Write-Host "Debug: new skip list count=$($skipList.Count)" -ForegroundColor Cyan }
    }

    foreach ($s in $skipList) {
        if (-not $s) { continue }
        $pattern = $s
        $patternTrim = $pattern
        if ($patternTrim) { $patternTrim = $patternTrim.Trim() }
        # if ($Debug) { Write-Host "Checking pattern: '$pattern' (trimmed: '$patternTrim')" -ForegroundColor Cyan }
        # �������ͨ�����ʹ�� -like ��ƥ������·�����ļ���
        if ($pattern -match '[\*\?]') {
            if ($fullPath -like $patternTrim -or $fileName -like $patternTrim) {
                if ($Debug) { Write-Host "Skip match (wildcard) '$pattern' -> '$filePath'" -ForegroundColor Yellow }
                return $true
            }
        }
        else {
            # ��ȷƥ������·��
            try {
                $resolvedSkip = [System.IO.Path]::GetFullPath($patternTrim) 2>$null
            } catch { $resolvedSkip = $null }
            if ($resolvedSkip -and ($resolvedSkip -eq $fullPath)) {
                if ($Debug) { Write-Host "Skip match (fullpath) '$pattern' -> '$filePath'" -ForegroundColor Yellow }
                return $true
            }

            # ��ȷƥ���ļ���
            if ($patternTrim -ieq $fileName -or $patternTrim -ieq $baseName) {
                if ($Debug) { Write-Host "Skip match (name) '$pattern' -> '$filePath'" -ForegroundColor Yellow }
                return $true
            }

            # ֧����·����βƥ�䣨���� 'subdir/file.txt' �� ����·����βƥ�䣩
            if ($patternTrim -and $fullPath.EndsWith($patternTrim, [System.StringComparison]::OrdinalIgnoreCase)) {
                if ($Debug) { Write-Host "Skip match (endswith) '$pattern' -> '$filePath'" -ForegroundColor Yellow }
                return $true
            }
        }
    }

    if ($Debug) { Write-Host "No skip match for '$filePath'" -ForegroundColor Green }
    return $false
}

# ���ú�������ֵ������
$rimeUserDir = Get-WeaselUserDir
$rimeInstallDir = Get-WeaselInstallDir
$rimeServerExecutable = Get-WeaselServerExecutable

function Stop-WeaselServer {
    if (-not $rimeServerExecutable) {
        Write-Host "���棺δ�ҵ�Weasel����˿�ִ�г�����ȷ������ȷ��װС�Ǻ����뷨" -ForegroundColor Yellow
        Exit-Tip 1
    } elseif (-not $SkipStopWeasel) {
        # ���ȳ��԰�������ǿ�ƽ��������� get-rime.ps1 �� KillWeaselServer �߼���
        $processName = 'WeaselServer'
        try {
            $proc = Get-Process -Name $processName -ErrorAction SilentlyContinue
        } catch {
            $proc = $null
        }
        if ($proc) {
            while ($proc) {
                try {
                    Stop-Process -Name $processName -Force -ErrorAction SilentlyContinue
                } catch {
                    # ����ֹͣ���󣬼�������
                }
                Start-Sleep -Seconds 0.5
                try {
                    $proc = Get-Process -Name $processName -ErrorAction SilentlyContinue
                } catch {
                    $proc = $null
                }
            }
            Write-Host "$processName has been killed" -ForegroundColor Green
        } else {
            # ���û���ҵ������еĽ��̣�����ͨ����ִ���ļ��� /q ������������ֹͣ������ԭ��Ϊ��Ϊ���ף�
            try {
                Start-Process -FilePath (Join-Path $rimeInstallDir $rimeServerExecutable) -ArgumentList '/q' -ErrorAction SilentlyContinue | Out-Null
                Write-Host "����ʹ�ÿ�ִ���ļ��� /q ��������ֹͣ����֧�֣�" -ForegroundColor Yellow
            } catch {
                Write-Host "�޷�������ִ���ļ�ֹͣ��$($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
    }
}

function Start-WeaselServer {
    if (-not $rimeServerExecutable) {
        Write-Host "���棺δ�ҵ�Weasel����˿�ִ�г�����ȷ������ȷ��װС�Ǻ����뷨" -ForegroundColor Yellow
        Exit-Tip 1
    } elseif (-not $SkipStopWeasel) {
        Start-Process -FilePath (Join-Path $rimeInstallDir $rimeServerExecutable)
    }
}

function Start-WeaselReDeploy{
    $defaultShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\С�Ǻ����뷨\��С�Ǻ������²���.lnk"
    $backupEnglishShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Weasel\Weasel Deploy.lnk"
    if ($disableAutoReDeploy) {
        Write-Host "�����������²���" -ForegroundColor Yellow
    } elseif (-not $SkipStopWeasel) {
        if (Test-Path -Path $defaultShortcutPath) {
            Write-Host "�ҵ�Ĭ�ϡ�С�Ǻ������²����ݷ�ʽ����ִ��" -ForegroundColor Green
            Invoke-Item -Path $defaultShortcutPath
        } elseif (Test-Path -Path $backupEnglishShortcutPath) {
            Write-Host "�ҵ�Ĭ�ϡ�С�Ǻ������²����ݷ�ʽ����ִ��" -ForegroundColor Green
            Invoke-Item -Path $backupEnglishShortcutPath
        } else {
            Write-Host "δ�ҵ�Ĭ�ϵġ�С�Ǻ������²����ݷ�ʽ��������ִ��Ĭ�ϵ����²�������" -ForegroundColor Yellow
            Write-Host "�����������²���" -ForegroundColor Yellow
        }
    }
}

# ����Ҫ·���Ƿ�Ϊ��
if (-not $rimeUserDir -or -not $rimeInstallDir -or -not $rimeServerExecutable) {
    Write-Host "�����޷���ȡWeasel��Ҫ·�����������뷨�Ƿ���ȷ��װ" -ForegroundColor Red
    Exit-Tip 1
}

# ����������ṩ�� cliTargetFolder ������������ʹ�ò���֤
if ($PSBoundParameters.ContainsKey('cliTargetFolder') -and $cliTargetFolder) {
    Write-Host "ͨ�� cli ���õ�Ŀ���ļ���Ϊ: $resolvedPath" -ForegroundColor Green
    $targetDir = $resolvedPath
} else {
    Write-Host "Weasel�û�Ŀ¼·��Ϊ: $rimeUserDir" -ForegroundColor Green
    $targetDir = $rimeUserDir
}

# ��Ŀ���û�Ŀ¼�´���ר����ʱĿ¼���ڱ������ص�zip�ȣ�����zip����������飩
$WanxiangTempDir = Join-Path $targetDir 'wanxiang_temp'
if (-not (Test-Path $WanxiangTempDir)) {
    try {
        New-Item -Path $WanxiangTempDir -ItemType Directory -Force | Out-Null
        Write-Host "�Ѵ�����ʱĿ¼: $WanxiangTempDir" -ForegroundColor Green
    } catch {
        Write-Host "���棺�޷�������ʱĿ¼ $WanxiangTempDir����ʹ��ϵͳ��ʱĿ¼" -ForegroundColor Yellow
        $WanxiangTempDir = $BaseTempPath
    }
}
# �� schema ��ʱ zip �ļ��������û�Ŀ¼�µ�ר����ʱĿ¼��
$tempSchemaZip = Join-Path $WanxiangTempDir "wanxiang_schema_temp.zip"
# �� dict ��ʱ zip �� gram ��ʱ�ļ�Ҳ���ڸ�Ŀ¼
$tempDictZip = Join-Path $WanxiangTempDir "wanxiang_dict_temp.zip"
$tempGram = Join-Path $WanxiangTempDir "wanxiang-lts-zh-hans.gram"

# ��Ϊ��Ҫ�ĸ��������Ӧ�Ľ�ѹĿ¼
$SchemaExtractPath = $null
$DictExtractPath = $null
$extractDirs = @()
if ($IsUpdateSchemaDown) {
    $SchemaExtractPath = Join-Path $WanxiangTempDir "wanxiang_schema_extract"
    $extractDirs += $SchemaExtractPath
}
if ($IsUpdateDictDown) {
    $DictExtractPath = Join-Path $WanxiangTempDir "wanxiang_dict_extract"
    $extractDirs += $DictExtractPath
}

foreach ($d in $extractDirs) {
    if (-not (Test-Path $d)) {
        try {
            New-Item -Path $d -ItemType Directory -Force | Out-Null
        }
        catch {
            Write-Host "�����޷�������ѹĿ¼ $d, $($_.Exception.Message)" -ForegroundColor Red
            Exit-Tip 1
        }
    }
}

if ($targetDir -eq $rimeUserDir) {
    $SkipStopWeasel = $false
} else {
    $SkipStopWeasel = $true
}

$TimeRecordFile = Join-Path $targetDir $ReleaseTimeRecordFile

function Test-VersionSuffix {
    param(
        [string]$url
    )
    # tag_name = v1.0.0 or v1.0
    $pattern = 'v(\d+)(\.\d+)+'
    if ($UseCnbMirrorSource) {
        return $url -match $pattern | Where-Object { $_ -notmatch $DictReleaseTag -and $_ -notmatch $GramReleaseTag }
    }
    else {
        return $url -match $pattern
    }
}

function Test-DictSuffix {
    param(
        [string]$url
    )

    return $url -match $DictReleaseTag
}

function Test-CnbGramSuffix {
    param(
        [string]$url
    )
    # tag_name = model
    return $url -match $GramReleaseTag
}

function Invoke-FileUtf8 {
    param(
        [Parameter(Mandatory=$true)][string]$Uri,
        [hashtable]$Headers
    )
    $tmp = [System.IO.Path]::GetTempFileName()
    try {
        Invoke-WebRequest -Uri $Uri -Headers $Headers -OutFile $tmp
        $bytes = [System.IO.File]::ReadAllBytes($tmp)
        $text  = [System.Text.Encoding]::UTF8.GetString($bytes)
        return $text
    } catch {
        Write-Error "�������ػ�����ļ�ʧ��: $Uri"
        Write-Error $_.Exception.Message
        Exit-Tip 1
    } finally {
            Remove-Item $tmp -ErrorAction SilentlyContinue
    }
}

function Get-CnbReleaseInfo {
    param(
        [string]$owner,
        [string]$repo,
        [string]$query
    )

    # https://cnb.cool/amzxyz/rime-wanxiang/-/releases?page=1&page_size=20&query=
    $apiUrl = "https://cnb.cool/$owner/$repo/-/releases?page=1&page_size=100&query=$query"

    try {
        Write-Host "���ڴ� CNB ҳ���ȡ��Ϣ: $apiUrl" -ForegroundColor Cyan
        $jsonDataTmp = Invoke-FileUtf8 -Uri $apiUrl -Headers $UriHeader
        $jsonDataFormat = $jsonDataTmp | ConvertFrom-Json
      
        if ($jsonDataFormat.releases){
            $releaseData = $jsonDataFormat.releases
            Write-Host "�ɹ���ȡ CNB release �汾��Ϣ" -ForegroundColor Green
            if ($jsonDataFormat.release_count -eq 0) {
                Write-Warning "CNB release �汾û�п�������Դ"
                return $null
            }
            return $releaseData
        } else {
            Write-Warning "���棺�� CNB ҳ����δ�ҵ� 'releases' ���ݡ�"
            return $null
        }
    }
    catch {
        Write-Warning "�������ػ����CNBҳ��ʧ��: $apiUrl"
        Write-Warning $_.Exception.Message
        return $null
    }
}

function Get-GithubReleaseInfo {
    param(
        [string]$owner,
        [string]$repo
    )
    # ����API����URL
    $apiUrl = "https://api.github.com/repos/$owner/$repo/releases"

    # ����API����ͷ
    $GitHubHeaders = @{
        "User-Agent" = "PowerShell Release Downloader"
        "Accept"     = "application/vnd.github.v3+json"
    }
    if ($env:GITHUB_TOKEN) {
        $GitHubHeaders["Authorization"] = "token $($env:GITHUB_TOKEN)"
    }
    
    try {
        # ����API����
        $response = Invoke-RestMethod -Uri $apiUrl -Headers $GitHubHeaders
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.Value__
        if ($statusCode -eq 404) {
            Write-Error "���󣺲ֿ� '$owner/$repo' �����ڻ�û�з����汾"
        }
        else {
            Write-Error "API����ʧ�� [$statusCode]��$_"
        }
        return $null
    }

    # ����Ƿ��п�������Դ
    if ($response.assets.Count -eq 0) {
        Write-Error "�ð汾û�п�������Դ"
        return $null
    }
    return $response
}

function Get-ReleaseInfo {
    param(
        [string]$owner,
        [string]$repo,
        [bool]$updateToolFlag = $false,
        [string]$query
    )
    # ���ȳ��� CNB�������ã����� CNB �����ݻ�ʧ�ܣ�����˵� GitHub
    if ($UseCnbMirrorSource) {
        $cnbResult = Get-CnbReleaseInfo -owner $owner -repo $repo -query $query
        if ($cnbResult) {
            return $cnbResult
        } else {
            Write-Host "CNB δ������Ч���ݣ����Ի��˵� GitHub ��ȡ������Ϣ..." -ForegroundColor Yellow
            $ghResult = Get-GithubReleaseInfo -owner $owner -repo $repo
            if ($ghResult) {
                return $ghResult
            } else {
                Write-Warning "�޷��� CNB �� GitHub ��ȡ�� '$owner/$repo' �ķ�����Ϣ��"
                return $null
            }
        }
    } else {
        $result = Get-GithubReleaseInfo -owner $owner -repo $repo
        if ($null -eq $result) {
            Write-Warning "�޷���ȡ�ֿ� '$owner/$repo' �ķ����汾��Ϣ��"
            return $null
        }
        return $result
    }
}

$UpdateToolsResponse = Get-GithubReleaseInfo -owner $UpdateToolsOwner -repo $UpdateToolsRepo
# ����Ƿ���Ҫ����������¼��
$SkipSelfUpdateCheck = $false
if ($null -eq $UpdateToolsResponse -or $UpdateToolsResponse.Count -eq 0) {
    $SkipSelfUpdateCheck = $true
    $UpdateToolsResponse = @() 
}

# ����Ƿ����°汾,�����ȡ�İ汾��Ϣ�����ڵİ汾��Ϣ(UpdateToolsVersion)�£�����ʾ�û�����
# �汾��ʽ:v3.4.0,v3.4.1,v3.4.1-rc1
if (-not $SkipSelfUpdateCheck) {
    if ($UpdateToolsResponse.Count -eq 0) {
        Write-Host "û���ҵ����¹��߰汾��Ϣ������������¼�顣" -ForegroundColor Yellow
    } else {
        $LatestUpdateToolsRelease = $UpdateToolsResponse | Select-Object -First 1
        if ($LatestUpdateToolsRelease.tag_name -ne $UpdateToolsVersion) {
            Write-Host "�����°汾�ĸ��¹���: $($LatestUpdateToolsRelease.tag_name)" -ForegroundColor Yellow
            Write-Host "�������,����� https://github.com/rimeinn/rime-wanxiang-update-tools/releases �������°汾" -ForegroundColor Yellow
            Write-Host "��ǰ�汾: $UpdateToolsVersion" -ForegroundColor Yellow
            Write-Host "������־: $($LatestUpdateToolsRelease.body)" -ForegroundColor Yellow
        } else {
            Write-Host "�ű������������°汾��$UpdateToolsVersion" -ForegroundColor Green
        }
    }
}

# ��ȡ���µİ汾��Ϣ
$SchemaResponse = Get-ReleaseInfo -owner $SchemaOwner -repo $SchemaRepo
if ($UseCnbMirrorSource) {
    $GramResponse = Get-ReleaseInfo -owner $SchemaOwner -repo $SchemaRepo -query "model"
} else {
    $GramResponse = Get-ReleaseInfo -owner $SchemaOwner -repo $GramRepo
}

$SelectedDictRelease = $null
$SelectedSchemaRelease = $null
$SelectedGramRelease = $null

function Get-ReleaseTagName {
    param(
        [object]$release
    )
    if ($UseCnbMirrorSource) {
        $tag_name = $release.tag_ref
    } else {
        $tag_name = $release.tag_name
    }
    return $tag_name
}

foreach ($release in $SchemaResponse) {
    $tag_name = Get-ReleaseTagName -release $release

    if (($null -eq $SelectedDictRelease) -and (Test-DictSuffix -url $tag_name)) {
        $SelectedDictRelease = $release
        continue
    }
    if ((-not $SelectedSchemaRelease) -and (Test-VersionSuffix -url $tag_name)) {
        $SelectedSchemaRelease = $release
    }
    if ($SelectedDictRelease -and $SelectedSchemaRelease) {
        break
    }
}

foreach ($release in $GramResponse) {
    $tag_name = Get-ReleaseTagName -release $release
    if ($Debug) {
        Write-Host "release.tag_name: $tag_name" -ForegroundColor Green
        Write-Host "GramReleaseTag: $GramReleaseTag" -ForegroundColor Green
    }
    if ($tag_name -match $GramReleaseTag) {
        $SelectedGramRelease = $release
    }
}

if ($SelectedDictRelease -and $SelectedSchemaRelease -and $SelectedGramRelease) {
    if (-not $UseCnbMirrorSource) {
        Write-Host "���������µĴʿ�����Ϊ��$($SelectedDictRelease.html_url)" -ForegroundColor Green
        Write-Host "���������µİ汾����Ϊ��$($SelectedSchemaRelease.html_url)" -ForegroundColor Green
        Write-Host "���������µ�ģ������Ϊ��$($SelectedGramRelease.html_url)" -ForegroundColor Green
    }
} else {
    Write-Error "δ�ҵ����������İ汾��ʿ�����"
    Exit-Tip 1
}

# ��ȡ���µİ汾��tag_name
if (-not $UseCnbMirrorSource) {
    Write-Host "�������µİ汾Ϊ��$($SelectedSchemaRelease.tag_name)"
    Write-Host "����������־: " -ForegroundColor Yellow
    Write-Host $SelectedSchemaRelease.body -ForegroundColor Yellow
} else {
    Write-Host "�������µİ汾Ϊ��$($SelectedSchemaRelease.tag_ref)"
    Write-Host "����������־: " -ForegroundColor Yellow
    Write-Host $SelectedSchemaRelease.body -ForegroundColor Yellow
}


$promptSchemaType = "��ѡ����Ҫ���صķ������͵ı��: `n$SchemaDownloadTip"
$promptAllUpdate = "�Ƿ�����������ݣ��������ʿ⡢ģ�ͣ�:`n[0]-��������; [1]-����������"
$promptSchemaDown = "�Ƿ����ط���:`n[0]-����; [1]-������"
$promptGramModel = "�Ƿ�����ģ��:`n[0]-����; [1]-������"
$promptDictDown = "�Ƿ����شʿ�:`n[0]-����; [1]-������"

if ($AutoUpdate) {
    Write-Host "�Զ�����ģʽ�����Զ��������µİ汾" -ForegroundColor Green
    Write-Host "�����õķ�����Ϊ��$InputSchemaType" -ForegroundColor Green
    # ������ֻ֧��0-6
    if ($InputSchemaType -lt 0 -or $InputSchemaType -gt 6) {
        Write-Error "���󣺷�����ֻ����0-6"
        Exit-Tip 1
    }
    $InputAllUpdate = "0"
    $InputSchemaDown = if ($IsUpdateSchemaDown)  { "0" } else { "1" }
    $InputGramModel = if ($IsUpdateModel)  { "0" } else { "1" }
    $InputDictDown = if ($IsUpdateDictDown)  { "0" } else { "1" }
} else {
    $InputSchemaType = Read-Host $promptSchemaType
    $InputAllUpdate = Read-Host $promptAllUpdate
    if ($InputAllUpdate -eq "0") {
        $InputSchemaDown = "0"
        $InputGramModel = "0"
        $InputDictDown = "0"
    } else {
        $InputSchemaDown = Read-Host $promptSchemaDown
        $InputGramModel = Read-Host $promptGramModel
        $InputDictDown = Read-Host $promptDictDown
    }
}

if ($InputSchemaType -eq "0") {
    $DictFileSaveDirTableIndex = "base"
} else {
    $DictFileSaveDirTableIndex = "pro"
}

# �����û�����ķ����Ż�ȡ��������
function Get-ExpectedAssetTypeInfo {
    param(
        [string]$index,
        [hashtable]$keyTable,
        [Object]$releaseObject
    )
    
    $info = $null
    
    foreach ($asset in $releaseObject.assets) {
        if ($Debug) {
            Write-Host "asset.name: $($asset.name)" -ForegroundColor Green
            Write-Host "keyTable[$index]: $($keyTable[$index])" -ForegroundColor Green
        }

        if ($asset.name -match $keyTable[$index]) {
            $info = $asset
            # ��ӡ
            if ($Debug) {
                Write-Host "ƥ��ɹ���asset.name: $($asset.name)" -ForegroundColor Green
                Write-Host "Ŀ����ϢΪ��$($info)"
            }
            break
        }
    }

    return $info
}

$ExpectedSchemaTypeInfo = Get-ExpectedAssetTypeInfo -index $InputSchemaType -keyTable $KeyTable -releaseObject $SelectedSchemaRelease
$ExpectedDictTypeInfo = Get-ExpectedAssetTypeInfo -index $InputSchemaType -keyTable $KeyTable -releaseObject $SelectedDictRelease
$ExpectedGramTypeInfo = Get-ExpectedAssetTypeInfo -index $GramFileTableIndex -keyTable $GramKeyTable -releaseObject $SelectedGramRelease

if (-not $ExpectedSchemaTypeInfo -or -not $ExpectedDictTypeInfo -or -not $ExpectedGramTypeInfo) {
    if (($InputSchemaDown -eq 0) -and (-not $ExpectedSchemaTypeInfo)) {
        Write-Error "δ�ҵ����������ķ�����������"
        Exit-Tip 1
    }
    if (($InputDictDown -eq 0) -and (-not $ExpectedDictTypeInfo)) {
        Write-Error "δ�ҵ����������Ĵʿ���������"
        Exit-Tip 1
    }
    if (($InputGramModel -eq 0) -and (-not $ExpectedGramTypeInfo)) {
        Write-Error "δ�ҵ�����������ģ����������"
        Exit-Tip 1
    }
}

# ��ӡ
if ($InputSchemaDown -eq "0") {
    Write-Host "���ط���" -ForegroundColor Green
    if ($Debug) {
        Write-Host "���µĸ����뷽��������ϢΪ��$($ExpectedSchemaTypeInfo)" -ForegroundColor Green
    }
}

if ($InputDictDown -eq "0") {
    Write-Host "���شʿ�" -ForegroundColor Green
    if ($Debug) {
        Write-Host "���µĸ�����ʿ�������ϢΪ��$($ExpectedDictTypeInfo)" -ForegroundColor Green
    }
}

if ($InputGramModel -eq "0") {
    Write-Host "����ģ��" -ForegroundColor Green
    if ($Debug) {
        Write-Host "���µĸ�����ģ��������ϢΪ��$($ExpectedGramTypeInfo)" -ForegroundColor Green
    }
}

function Save-TimeRecord {
    param(
        [string]$filePath,
        [string]$key,
        [string]$value
    )
    
    $timeData = @{}
    if (Test-Path $filePath) {
        try {
            if ($PSVersionTable.PSVersion.Major -ge 7) {
                $timeData = Get-Content $filePath | ConvertFrom-Json -AsHashtable
            } else {
                $timeData = Get-Content $filePath | ConvertFrom-Json | ForEach-Object {
                    $ht = @{}
                    $_.PSObject.Properties | ForEach-Object { $ht[$_.Name] = $_.Value }
                    $ht
                }
            }
        }
        catch {
            Write-Host "���棺�޷���ȡʱ���¼�ļ����������µļ�¼" -ForegroundColor Yellow
        }
    }

    $timeData[$key] = $value
    
    try {
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            $timeData | ConvertTo-Json | Set-Content $filePath
        } else {
            $timeData | ConvertTo-Json -Depth 100 | Set-Content $filePath
        }
    }
    catch {
        Write-Host "�����޷�����ʱ���¼" -ForegroundColor Red
    }
}

function Get-TimeRecord {
    param(
        [string]$filePath,
        [string]$key
    )
    
    if (Test-Path $filePath) {
        try {
            if ($PSVersionTable.PSVersion.Major -ge 7) {
                $timeData = Get-Content $filePath | ConvertFrom-Json -AsHashtable
            } else {
                $json = Get-Content $filePath | ConvertFrom-Json
                $timeData = @{}
                $json.PSObject.Properties | ForEach-Object { $timeData[$_.Name] = $_.Value }
            }
            return $timeData[$key]
        }
        catch {
            Write-Host "���棺�޷���ȡʱ���¼�ļ�" -ForegroundColor Yellow
        }
    }
    return $null
}

# �Ƚϱ��غ�Զ�̸���ʱ��
function Compare-UpdateTime {
    param(
        [Object]$localTime,
        [datetime]$remoteTime
    )

    if ($null -eq $localTime) {
        Write-Host "����ʱ���¼�����ڣ��������µ�ʱ���¼" -ForegroundColor Yellow
        return $true
    }

    $localTime = [datetime]::Parse($localTime)

    if ($null -eq $remoteTime) {
        Write-Host "Զ��ʱ���¼�����ڣ��޷��Ƚ�" -ForegroundColor Red
        return $false
    }
    
    if ($remoteTime -gt $localTime) {
        Write-Host "�����°汾��׼������" -ForegroundColor Yellow
        return $true
    }
    Write-Host "��ǰ�������°汾" -ForegroundColor Yellow
    return $false
}

# ��JSON�ļ����ز�����UpdateTimeKey
function Read-UpdateTimeKey {
    param(
        [string]$filePath
    )
    
    if (-not (Test-Path $filePath)) {
        Write-Host "���棺ʱ���¼�ļ�������" -ForegroundColor Yellow
        return $null
    }
    
    try {
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            $timeData = Get-Content $filePath | ConvertFrom-Json -AsHashtable
        } else {
            $json = Get-Content $filePath | ConvertFrom-Json
            $timeData = @{}
            $json.PSObject.Properties | ForEach-Object { $timeData[$_.Name] = $_.Value }
        }
        return $timeData
    }
    catch {
        Write-Host "�����޷�����JSON�ļ�" -ForegroundColor Red
        return $null
    }
}

# ���ʱ���¼�ļ�
$hasTimeRecord = Read-UpdateTimeKey -filePath $TimeRecordFile

if (-not $hasTimeRecord) {
    Write-Host "ʱ���¼�ļ������ڣ��������µ�ʱ���¼" -ForegroundColor Yellow
}

# ����Ŀ��Ŀ¼����������ڣ�
if (-not (Test-Path $targetDir)) {
    Write-Host "����Ŀ��Ŀ¼: $targetDir" -ForegroundColor Green
    New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
}

function Test-FileSHA256 {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath,
        [Parameter(Mandatory=$true)]
        [string]$CompareSHA256
    )

    if (-not (Test-Path $FilePath)) {
        Write-Host "�ļ������ڣ�$FilePath" -ForegroundColor Red
        return $false
    }

    $hash = Get-FileHash -Path $FilePath -Algorithm SHA256
    if ($hash.Hash.ToLower() -eq $CompareSHA256.ToLower()) {
        Write-Host "SHA256 ƥ�䡣" -ForegroundColor Green
        return $true
    } else {
        Write-Host "SHA256 ��ƥ�䡣" -ForegroundColor Red
        Write-Host "�ļ� SHA256: $($hash.Hash)"
        Write-Host "���� SHA256: $CompareSHA256"
        return $false
    }
}

# ���غ���
function Save-Asset {
    param(
        [Object]$assetInfo,
        [string]$outFilePath
    )
    
    try {
        if ($UseCnbMirrorSource) {
            $downloadUrl = "https://cnb.cool" + $assetInfo.path
        } else {
            $downloadUrl = $assetInfo.browser_download_url
        }
        
        Write-Host "���������ļ�:$($assetInfo.name)..." -ForegroundColor Green

        if ($UseCurl) {
            curl.exe -L -o $outFilePath --progress-bar $downloadUrl
        } else {
            Invoke-WebRequest -Uri $downloadUrl -OutFile $outFilePath -UseBasicParsing
        }
        Write-Host "�������" -ForegroundColor Green

        if ($UseCnbMirrorSource) {
            # У���ļ���С
            $expectedSize = [int64]$assetInfo.size_in_byte
            $actualSize = (Get-Item $outFilePath).Length
            if ($expectedSize -ne $actualSize) {
                Write-Host "�ļ���СУ��ʧ�ܣ�ɾ���ļ�" -ForegroundColor Red
                Write-Host "������С: $expectedSize �ֽڣ�ʵ�ʴ�С: $actualSize �ֽ�" -ForegroundColor Red
                Remove-Item -Path $outFilePath -Force
                Exit-Tip 1
            }
        } else {
            $SHA256 = $assetInfo.digest.Split(":")[1]
            if (-not (Test-FileSHA256 -FilePath $outFilePath -CompareSHA256 $SHA256)) {
                Write-Host "SHA256 У��ʧ�ܣ�ɾ���ļ�" -ForegroundColor Red
                Remove-Item -Path $outFilePath -Force
                Exit-Tip 1
            }
        }
    }
    catch {
        Write-Host "����ʧ��: $_" -ForegroundColor Red
        Exit-Tip 1
    }
}

# ��ѹ zip �ļ�
function Expand-ZipFile {
    param(
        [string]$zipFilePath,
        [string]$destinationPath
    )
 
    try {
        Write-Host "���ڽ�ѹ�ļ�: $zipFilePath" -ForegroundColor Green
        Write-Host "��ѹ��: $destinationPath" -ForegroundColor Green
 
        # --- ��ȡ 7z.exe ·�� ---
        $weaselRootDir = Get-WeaselInstallDir
        if (-not $weaselRootDir) {
            Throw "�޷���ȡС�Ǻ����뷨��װĿ¼������޷���λ 7z.exe ���н�ѹ��"
        }
        $sevenZipPath = Join-Path $weaselRootDir "7z.exe"
 
        # ��� 7z.exe �Ƿ����
        if (-not (Test-Path $sevenZipPath -PathType Leaf)) {
            Throw "�Ҳ��� 7z.exe��Ԥ��·��: '$sevenZipPath'����ȷ��С�Ǻ����뷨��װ�����Ұ��� 7z.exe"
        }
        Write-Host "���ҵ� 7z.exe��$sevenZipPath" -ForegroundColor DarkCyan
 
        # --- ȷ��Ŀ��Ŀ¼���� ---
        if (-not (Test-Path $destinationPath)) {
            try {
                New-Item -Path $destinationPath -ItemType Directory -Force | Out-Null
                Write-Host "�Ѵ���Ŀ��Ŀ¼: $destinationPath" -ForegroundColor Yellow
            }
            catch {
                Throw "����Ŀ��Ŀ¼ '$destinationPath' ʧ��: $($_.Exception.Message)��"
            }
        }
 
        # --- ���� 7z.exe ���н�ѹ ---
        $arguments = "x `"$zipFilePath`" -o`"$destinationPath`" -y"
        Write-Host "���ڵ��� 7-Zip ���н�ѹ..." -ForegroundColor DarkGreen
 
        $process = Start-Process -FilePath $sevenZipPath -ArgumentList $arguments -Wait -PassThru -NoNewWindow
      
        if ($process.ExitCode -ne 0) {
            Throw "7-Zip ��ѹʧ�ܣ��˳�����: $($process.ExitCode)��"
        }
      
        Write-Host "��ѹ���" -ForegroundColor Green
    }
    catch {
        Write-Host "��ѹʧ��: $($_.Exception.Message)" -ForegroundColor Red
        Remove-Item -Path $zipFilePath -Force -ErrorAction SilentlyContinue
        Exit-Tip 1
    }
}

if ($SkipStopWeasel) {
    Write-Host "�����õĲ���Ŀ¼��С�Ǻ����õ��û�Ŀ¼��ͬ������С�Ǻ�����ֹͣ����" -ForegroundColor Red
} elseif ($InputSchemaDown -eq "0" -or $InputDictDown -eq "0" -or $InputGramModel -eq "0") {
    # ��ʼ���´ʿ⣬�����ڿ�ʼ��Ҫ�������̣�ֱ��������ɣ�����ᴥ��С�Ǻ��������ļ����¸澯�����¸���ʧ�ܣ�����ĸ�����ɺ���Զ�����С�Ǻ�
    Write-Host "���ڸ��´ʿ⣬�벻Ҫ�������̣�ֱ���������" -ForegroundColor Red
    Write-Host "������ɺ���Զ�����С�Ǻ�" -ForegroundColor Red
} else {
    Write-Host "û��ָ��Ҫ���µ����ݣ����˳�" -ForegroundColor Red
    Exit-Tip 0
}

function Get-UpdateAtObj {
    param (
        [object]$assetInfo
    )
    return $assetInfo.updated_at
}

$UpdateFlag = $false

if ($InputSchemaDown -eq "0") {
    # ���ط���
    $SchemaUpdateTimeKey = $KeyTable[$InputSchemaType] + "_schema_update_time"
    $SchemaUpdateTime = Get-TimeRecord -filePath $TimeRecordFile -key $SchemaUpdateTimeKey
    $SchemaRemoteTime = [datetime]::Parse($(Get-UpdateAtObj -assetInfo $ExpectedSchemaTypeInfo))
    Write-Host "���ڼ�鷽���Ƿ���Ҫ����..." -ForegroundColor Yellow
    Write-Host "����ʱ��: $SchemaUpdateTime" -ForegroundColor Green
    Write-Host "Զ��ʱ��: $SchemaRemoteTime" -ForegroundColor Green
    if (Compare-UpdateTime -localTime $SchemaUpdateTime -remoteTime $SchemaRemoteTime) {
        $UpdateFlag = $true
        Write-Host "�������ط���..." -ForegroundColor Green
        Save-Asset -assetInfo $ExpectedSchemaTypeInfo -outFilePath $tempSchemaZip
        Write-Host "���ڽ�ѹ����..." -ForegroundColor Green
        Expand-ZipFile -zipFilePath $tempSchemaZip -destinationPath $SchemaExtractPath
        Write-Host "���ڸ����ļ�..." -ForegroundColor Green
        # ��������û�����ļ��У�ֱ�Ӹ��Ƶ�Ŀ��Ŀ¼
        $sourceDir = $SchemaExtractPath
        if (-not (Test-Path $sourceDir)) {
            Write-Host "����ѹ������δ�ҵ� $sourceDir Ŀ¼" -ForegroundColor Red
            # �������ص� zip �Ա���������ֶ�������Ȼ�����ѹĿ¼
            Remove-Item -Path $SchemaExtractPath -Recurse -Force
            Exit-Tip 1
        }
        Stop-WeaselServer
        # �ȴ�1��
        Start-Sleep -Seconds 1
        Get-ChildItem -Path $sourceDir -Recurse | ForEach-Object {
            # Write-Host "SkipFiles: $SkipFiles"
            if (Test-SkipFile -filePath $_.Name) {
                Write-Host "�����ļ�: $($_.Name)" -ForegroundColor Yellow
            } else {
                # $relativePath = Resolve-Path -path $_.FullName -RelativeBasePath $sourceDir -Relative
                $relativePath = $_.FullName.Substring($sourceDir.Length)
                # ȥ�����ܵĿ�ͷ�� .\ �� ./������ Join-Path ��������� \\.\ ��·��
                # ʹ�������滻�Ա��� TrimStart �ڴ��� '\\' ʱ�����ʹ���
                $relativePath = $relativePath -replace '^[.][\\/]+',''
                $destinationPath = Join-Path $targetDir $relativePath
                $destinationDir = [System.IO.Path]::GetDirectoryName($destinationPath)
                if (-not (Test-Path $destinationDir)) {
                    New-Item -ItemType Directory -Path $destinationDir | Out-Null
                }
                if (Test-Path $_.FullName -PathType Container) {
                    
                } elseif (Test-Path $_.FullName -PathType Leaf) {
                    Copy-Item -Path $_.FullName -Destination $destinationPath -Force
                    if ($Debug) {
                        Write-Host "���ڸ����ļ�: $($_.Name)" -ForegroundColor Green
                        Write-Host "���·��: $relativePath" -ForegroundColor Green
                        Write-Host "Ŀ��·��: $destinationPath" -ForegroundColor Green
                    }
                }
            }
        }

        # �����ڵı���ʱ���¼��JSON�ļ�
        Save-TimeRecord -filePath $TimeRecordFile -key $SchemaUpdateTimeKey -value $SchemaRemoteTime
        # �����ѹĿ¼���������ص� zip��
        Remove-Item -Path $SchemaExtractPath -Recurse -Force
    }
}

if ($InputDictDown -eq "0") {
    # ���شʿ�
    $DictUpdateTimeKey = $KeyTable[$InputSchemaType] + "_dict_update_time"
    $DictUpdateTime = Get-TimeRecord -filePath $TimeRecordFile -key $DictUpdateTimeKey
    $DictRemoteTime = [datetime]::Parse($(Get-UpdateAtObj -assetInfo $ExpectedDictTypeInfo))
    Write-Host "���ڼ��ʿ��Ƿ���Ҫ����..." -ForegroundColor Yellow
    Write-Host "����ʱ��: $DictUpdateTime" -ForegroundColor Green
    Write-Host "Զ��ʱ��: $DictRemoteTime" -ForegroundColor Green
    if (Compare-UpdateTime -localTime $DictUpdateTime -remoteTime $DictRemoteTime) {
        $UpdateFlag = $true
        Write-Host "�������شʿ�..." -ForegroundColor Green
        Save-Asset -assetInfo $ExpectedDictTypeInfo -outFilePath $tempDictZip
        Write-Host "���ڽ�ѹ�ʿ�..." -ForegroundColor Green
        Expand-ZipFile -zipFilePath $tempDictZip -destinationPath $DictExtractPath
        Write-Host "���ڸ����ļ�..." -ForegroundColor Green
        $sourceDir = Get-DictExtractedFolderPath -extractPath $DictExtractPath -assetName $KeyTable[$InputSchemaType]
        if (-not (Test-Path $sourceDir)) {
            Write-Host "����ѹ������δ�ҵ� $sourceDir Ŀ¼" -ForegroundColor Red
            Remove-Item -Path $DictExtractPath -Force -Recurse
            Exit-Tip 1
        }
        Stop-WeaselServer
        # �ȴ�1��
        Start-Sleep -Seconds 1
        if (-not (Test-Path -Path $(Join-Path $targetDir $DictFileSaveDirTable[$DictFileSaveDirTableIndex]))){
            New-Item -ItemType Directory -Path $(Join-Path $targetDir $DictFileSaveDirTable[$DictFileSaveDirTableIndex]) | Out-Null
        }
        Get-ChildItem -Path $sourceDir | ForEach-Object {
            if ($Debug) {
                Write-Host "���ڸ����ļ�: $($_.Name)" -ForegroundColor Green
            }
            if (Test-SkipFile -filePath $_.Name) {
                Write-Host "�����ļ�: $($_.Name)" -ForegroundColor Yellow
            } else {
                Copy-Item -Path $_.FullName -Destination $(Join-Path $targetDir $DictFileSaveDirTable[$DictFileSaveDirTableIndex]) -Recurse -Force
            }
        }

        # �����ڵı���ʱ���¼��JSON�ļ�
        Save-TimeRecord -filePath $TimeRecordFile -key $DictUpdateTimeKey -value $DictRemoteTime -isDict $true
        # ������ʱ�ļ�
        Remove-Item -Path $DictExtractPath -Recurse -Force
    }
}

function Update-GramModel {
    Write-Host "��������ģ��..." -ForegroundColor Green
    Save-Asset -assetInfo $ExpectedGramTypeInfo -outFilePath $tempGram
    Write-Host "���ڸ����ļ�..." -ForegroundColor Green

    Stop-WeaselServer
    # �ȴ�1��
    Start-Sleep -Seconds 1
    Copy-Item -Path $tempGram -Destination $targetDir -Force
    # �����ڵı���ʱ���¼��JSON�ļ�
    Save-TimeRecord -filePath $TimeRecordFile -key $GramUpdateTimeKey -value $GramRemoteTime
    # ������ʱ�ļ�
    Remove-Item -Path $tempGram -Force
}

if ($InputGramModel -eq "0") {
    # ����ģ��
    $GramUpdateTimeKey = $GramReleaseTag + "_gram_update_time"
    $GramUpdateTime = Get-TimeRecord -filePath $TimeRecordFile -key $GramUpdateTimeKey
    $GramRemoteTime = [datetime]::Parse($(Get-UpdateAtObj -assetInfo $ExpectedGramTypeInfo))
    Write-Host "���ڼ��ģ���Ƿ���Ҫ����..." -ForegroundColor Yellow
    # ���Ŀ���ļ� $targetDir/$tempGram �Ƿ����
    $filePath = Join-Path $targetDir $GramModelFileName
    if ($Debug) {
        Write-Host "ģ���ļ�·��: $filePath" -ForegroundColor Green
    }
    Write-Host "����ʱ��: $GramUpdateTime" -ForegroundColor Green
    Write-Host "Զ��ʱ��: $GramRemoteTime" -ForegroundColor Green
    if (Compare-UpdateTime -localTime $GramUpdateTime -remoteTime $GramRemoteTime) {
        Update-GramModel
        $UpdateFlag = $true
    } elseif (Test-Path -Path $filePath) {
        if ($UseCnbMirrorSource) {
            # У���ļ���С
            $expectedSize = [int64]$ExpectedGramTypeInfo.size_in_byte
            $actualSize = (Get-Item $filePath).Length
            if ($expectedSize -ne $actualSize) {
                Write-Host "�ļ���СУ��ʧ�ܣ���Ҫ����" -ForegroundColor Red
                Write-Host "������С: $expectedSize �ֽڣ�ʵ�ʴ�С: $actualSize �ֽ�" -ForegroundColor Red
                Remove-Item -Path $filePath -Force
                Update-GramModel
                $UpdateFlag = $true
            }
        } else {
            # ����Ŀ���ļ���SHA256
            $localSHA256 = (Get-FileHash $filePath -Algorithm SHA256).Hash.ToLower()
            # ����Զ���ļ���SHA256
            $remoteSHA256 = $ExpectedGramTypeInfo.digest.Split(":")[1].ToLower()
            # �Ƚ�SHA256
            if ($localSHA256 -ne $remoteSHA256) {
                Write-Host "ģ��SHA256��ƥ�䣬��Ҫ����" -ForegroundColor Red
                Update-GramModel
                $UpdateFlag = $true
            }
        }
    } else {
        Write-Host "ģ�Ͳ����ڣ���Ҫ����" -ForegroundColor Red
        Update-GramModel
    }
}

foreach ($d in $extractDirs) {
    if (Test-Path $d) {
        try {
            Remove-Item -Path $d -Recurse -Force
            Write-Host "��ɾ����ʱ��ѹĿ¼ $d" -ForegroundColor Green
        }
        catch {
            Write-Host "�����޷�ɾ����ʱ��ѹĿ¼ $d" -ForegroundColor Red
            Exit-Tip 1
        }
    }
}

if ($UpdateFlag) {
    if ($disableAutoReDeploy) {
        Write-Host "�����������²���" -ForegroundColor Yellow
    } elseif (-not $SkipStopWeasel) {
        Start-WeaselServer
        # �ȴ�1��
        Start-Sleep -Seconds 1
        Write-Host "���ݸ��£�����С�Ǻ����²���..." -ForegroundColor Green
        Start-WeaselReDeploy
    }
}

if ($UpdateFlag) {
    Write-Host "��������ɣ��ļ��Ѳ��� Weasel ����Ŀ¼:$($targetDir)" -ForegroundColor Green
} else {
    Write-Host "��������ɣ���ϲ��! �����ļ��������µĲ���Ҫ���� " -ForegroundColor Green
}

Exit-Tip 0
