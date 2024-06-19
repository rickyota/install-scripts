#!/bin/bash

# set env variable of OS and architecture
# https://blog.entek.org.uk/notes/2021/07/27/platform-detection-with-lmod.html
# lmod documentation
# https://buildmedia.readthedocs.org/media/pdf/lmod/latest/lmod.pdf

MODROOT=/nfs/data06/ricky/app
APP=hpcenv
VER=1

APPDIR=$MODROOT/$APP #/$OSVER
mkdir -p $APPDIR && cd $APPDIR

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- OS variables
local os_fullname = "UNKNOWN"
-- local os_shortname = "UNKNOWN"
local os_version = "UNKNOWN"
local os_version_major = "UNKNOWN"
local os_distribution = "UNKNOWN"
-- Architecture variables
-- local arch_platform = "UNKNOWN"
-- local arch_cpu_fullname = "UNKNOWN"
-- local arch_cpu_shortname = "UNKNOWN"
-- local arch_cpu_compat = ""

function file_exists(file_name)
    local file_found = io.open(file_name, "r")
    if file_found == nil then
        return false
    else
        return true
    end
end

function get_command_output(command)
    -- Run a command and return the output with whitespace stripped from the end
    local s=capture(command)
    local s=string.gsub(s, '%s+$', '')
    local s=string.gsub(s, '^%s+', '')
    return s
    -- return string.gsub(capture(command), '%s+$', '')


end

function detect_os()
    -- Detect the operating system

    -- ng: dict does not work...
    -- local short_version_table = {
    --     Scientific = "EL",
    --     RedHatEnterpriseServer = "EL",
    --     CentOS = "EL",
    --     RedHatEnterprise = "EL",
    --     Debian = "Deb",
    --     Ubuntu = "Ubt"
    -- }

    if file_exists("/usr/bin/lsb_release") then
        -- 'rocky linux' coud be here
        -- ok but cannot strip space, so let get_command_output to strip
        os_version = get_command_output("lsb_release -r | sed 's/^Release://'")
        -- TODO: ng: sed regex not affect...
        -- os_version = get_command_output("lsb_release -r | sed 's/^Release: //'")
        -- regex does not work well...
        -- os_version = get_command_output("lsb_release -r | sed 's/^Release:[[:space:]]\+\([0-9.]\+\)$/\1/'")


        -- 'Rocky': rocky linux
        os_distribution = get_command_output("lsb_release -i | sed 's/^Distributor ID://'")
        -- os_distribution = get_command_output("lsb_release -i | sed 's/Distributor ID:[[:space:]]\+\([a-zA-Z0-9]\+\)$/\1/'")

        os_fullname = os_distribution .. "-" .. os_version

        if os_distribution == "Ubuntu" then
            -- Ubuntu is unique in that the version after the dot is not a minor release number
            os_version_major = os_version
        else
            os_version_major = string.sub(os_version, string.find(os_version, '^%d+'))
            -- os_version_major = get_command_output("lsb_release -r | cut -f2,2 | cut -d'.' -f1,1")
        end
        -- os_shortname = short_version_table[os_distribution] .. "-" .. os_version_major
    elseif file_exists("/etc/centos-release") then
        -- 'centos' or 'rocky linux'
        -- ng: not sure why...?
        -- execute {cmd="source /etc/os-release",modeA={"load"}}
        -- os_version = os.getenv("VERSION_ID")
        -- ng: not sure why...?  output is nil
        -- os_version=get_command_output("source /etc/os-release && echo $VERSION_ID")
        -- LmodError("os_version: " .. os_version)
        os_fullname = get_command_output("cat /etc/centos-release")
        if string.find(os_fullname, "CentOS") ~= nil  then
            os_distribution = "CentOS"
            os_version = get_command_output("cat /etc/centos-release | sed 's/^CentOS Linux release //' | sed 's/(Core)$//'")
            os_version_major = string.sub(os_version, string.find(os_version, '^%d+'))
        elseif string.find(os_fullname, "Rocky Linux") ~= nil then
            -- same as when lsb_release exists
            os_distribution = "Rocky"
            -- os_distribution = "Rocky Linux"
            os_version = get_command_output("cat /etc/centos-release | sed 's/^Rocky Linux release //'")
            os_version = string.sub(os_version, string.find(os_version, '^%d+.%d+'))
            os_version_major = string.sub(os_version, string.find(os_version, '^%d+'))
        else
            LmodError("Unknown distribution for centos-release.")
        end
    else
        LmodError("No lsb_release command in /usr/bin - this version of the module has no fallback detection methods.")
    end
end


function detect_arch()
    -- Detect architecture information
    local cpu_family = get_command_output("grep -m1 '^cpu family[[:space:]:]\+' /proc/cpuinfo | sed 's/^cpu family[[:space:]:]\+\([0-9]\+\)$/\1/'")
    local cpu_model = get_command_output("grep -m1 '^model[[:space:]:]\+' /proc/cpuinfo | sed 's/^model[[:space:]:]\+\([0-9]\+\)$/\1/'")
    local cpu_flags = get_command_output("grep -m1 '^flags[[:space:]:]\+' /proc/cpuinfo | sed 's/^flags[[:space:]:]\+\(.\+\)$/\1/'")

    -- We need to detect for Azure:
    --   Dv3: Haswell, Broadwell, Skylake or Cascade Lake
    --   Fsv2: Skylake or Cascade Lake
    --   NCv2: Broadwell
    --   NCv3: Broadwell
    --   HB: AMD Zen 1
    --   HBv2: AMD Zen 2
    --   HC: Skylake
    -- I also have an IvyBridge system as my home lab, so detect that

    -- cpu_family and cpu_model are integer codes, so we need some lookup-tables (made by examining /proc/cpuinfo on available systems)
    -- Treat Broadwell as being Haswell due to compatible instructon sets
    local cpu_table = {
        ["6"] = {
            ["58"] = "san", -- IvyBridge
            ["63"] = "has", -- Haswell
            ["71"] = "has", -- Broadwell
            ["79"] = "has", -- Broadwell
            ["86"] = "has", -- Broadwell
            ["85"] = "sky", -- Skylake or Cascade Lake
        },
        ["23"] = {
            ["1"] = "zen", -- AMD Zen 1
            ["49"] = "zen2", -- AMD Zen 2
        },
    }

    -- Only really care about the family to detect Intel vs AMD (grouped the cpu_table by it for my benefit)
    local cpu_plat_table = {
        ["6"] = "intel",
        ["23"] = "amd",
    }

    -- Human friendly CPU names
    local cpu_names = {
        san = 'SandyBridge of IvyBridge',
        has = 'Haswell or Broadwell',
        sky = 'Skylake',
        cas = 'Cascade Lake',
        zen = 'AMD EPYC Zen',
        zen2 = 'AMD EPYC Zen 2',
    }

    -- List of compatible architectures (i.e. subset of same instruction set)
    local backward_compat = {
        sky = {'has'},
        cas = {'sky', 'has'},
        zen2 = {'zen'},
    }

    local cpu_family_name = cpu_table[cpu_family][cpu_model]

    if cpu_family_name == "sky" then
        -- Skylake with avx512 VNNI is Cascade Lake
        -- see: https://en.wikipedia.org/wiki/AVX-512#CPUs_with_AVX-512
        if string.find(cpu_flags, 'avx512_vnni') then
            cpu_family_name = 'cas'
        end
    end

    arch_platform = cpu_plat_table[cpu_family]
    arch_cpu_shortname = cpu_family_name
    arch_cpu_fullname = cpu_names[arch_cpu_shortname]
    if backward_compat[arch_cpu_shortname] ~= nil then
        arch_cpu_compat = table.concat(backward_compat[arch_cpu_shortname], ' ')
    end
end


-- Detection is (relatively) expensive to do, so only do it if needed
-- (Lmod will quite happily unset these variables on unload even if the values don't match)
if mode() == "load" then
    detect_os()
    -- detect_arch()
end

-- Export the OS variables
setenv("HPC_OS_FULL", os_fullname)
-- setenv("HPC_OS_SHORT", os_shortname)
setenv("HPC_OS_VER", os_version)
setenv("HPC_OS_VER_MAJOR", os_version_major)
setenv("HPC_OS_DIST", os_distribution)
-- Export the architecture variables
-- setenv("HPC_ARCH_CPU_FULLNAME", arch_cpu_fullname)
-- setenv("HPC_ARCH_CPU_SHORTNAME", arch_cpu_shortname)
-- setenv("HPC_ARCH_CPU_COMPAT", arch_cpu_compat)
-- setenv("HPC_ARCH_PLATFORM", arch_platform)

__END__
