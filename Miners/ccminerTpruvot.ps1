if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$Path = ".\Bin\NVIDIA-Tpruvot\ccminer.exe"
$Uri = "https://github.com/nemosminer/ccminerTpruvot/releases/download/v2.3-cuda10/ccminertpruvotx32.7z"

$Commands = [PSCustomObject]@{
    "allium"     = " -d $($Config.SelGPUCC)" #Allium
    "exosis"     = " -d $($Config.SelGPUCC)" #Exosis
    "hmq1725"    = " -d $($Config.SelGPUCC)" #hmq1725
    "lyra2z"     = " -d $($Config.SelGPUCC) --submit-stale" #Lyra2z
    "phi"        = " -d $($Config.SelGPUCC)" #Phi (testing)
    "sha256t"    = " -d $($Config.SelGPUCC) -i 29" #Sha256t
    "skunk"      = " -d $($Config.SelGPUCC)" #Skunk
    "sonoa"      = " -d $($Config.SelGPUCC)" #Sonoa
    "tribus"     = " -d $($Config.SelGPUCC)" #Tribus
    #"blake2s" = " -d $($Config.SelGPUCC) --api-remote --api-allow=0/0" #Blake2s
    #"bitcore"    = " -d $($Config.SelGPUCC)" #Bitcore(spmodbitcore faster)
    #"c11"        = " -d $($Config.SelGPUCC)" #C11
    #"cryptonight" = " -i 10 -d $($Config.SelGPUCC)" #Cryptonight
    #"decred" = "" #Decred
    #"equihash" = "" #Equihash
    #"ethash" = "" #Ethash
    #"groestl"    = " -d $($Config.SelGPUCC)" #Groestl
    #"hsr" = " -d $($Config.SelGPUCC)" #Hsr
    #"jha"        = " -d $($Config.SelGPUCC)" #Jha
    #"keccak"     = " -d $($Config.SelGPUCC) -i 29" #Keccak
    #"keccakc"    = " -d $($Config.SelGPUCC) -i 29" #Keccakc
    #"lyra2v2"    = " -d $($Config.SelGPUCC)" #Lyra2RE2
    #"myr-gr"     = " -d $($Config.SelGPUCC)" #MyriadGroestl
    #"neoscrypt"  = " -d $($Config.SelGPUCC)" #NeoScrypt
    #"nist5" = " -d $($Config.SelGPUCC) --api-remote --api-allow=0/0" #Nist5
    #"pascal" = "" #Pascal
    #"phi2"       = " -d $($Config.SelGPUCC)" #Phi2 (testing)
    #"polytimos"  = " -d $($Config.SelGPUCC)" #Polytimos
    #"qubit" = "" #Qubit
    #"scrypt" = "" #Scrypt
    #"sia" = "" #Sia
    #"sib"        = " -d $($Config.SelGPUCC)" #Sib
    #"timetravel" = " -d $($Config.SelGPUCC)" #Timetravel
    #"vanilla" = "" #BlakeVanilla
    #"veltor" = "" #Veltor
    #"x11evo"     = " -d $($Config.SelGPUCC)" #X11evo (Alexis78 faster)
    #"x13" = " -d $($Config.SelGPUCC) -r 0 -i 20 -N 1" #X13
    #"x16r"       = " -d $($Config.SelGPUCC)" #X16r
    #"x16s"       = " -d $($Config.SelGPUCC)" #X16s
    #"x17"        = " -d $($Config.SelGPUCC)" #X17(Enemy1.03 faster)
    #"yescrypt" = "" #Yescrypt
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "--cpu-priority 5 -b $($Variables.NVIDIAMinerAPITCPPort) -N 1 -R 1 -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API       = "ccminer"
        Port      = $Variables.NVIDIAMinerAPITCPPort
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.(Get-Algorithm($_)).User
        Host = $Pools.(Get-Algorithm $_).Host
        Coin = $Pools.(Get-Algorithm $_).Coin
    }
}
