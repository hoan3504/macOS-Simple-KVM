# Glossary

   ## ESP.qcow2    
       bootloader ,kind of super simplified Clover bootloader
       
   ## InstallerMedia   BaseSystem.img
       netInstaller tool  , similar to mini.iso netinstaller for Debian linux
       
   ## SystemDisk      
         macOS.qcow2    The operating system finalised on a disk
         
# InstallerImage

   ## BaseSystem.dmg   InstallESD.dmg

# Packagings
         pkg  dmg  iso                                                                       
         
         
# Operating environments

        mac  linux  ( let's fortget windows )
   mac and linux have smilarities but behave so much differently;
   let's go about installerimage.
   In linux most of "iso" are installerimage (beside the fact they could be running live).
   Roughly speaking "iso" contain a bootloader + a rootfilesystem (compressed). Since mac 
   has a very rich usage of packaging (pkg iso dmg )the installerimage for mac appears as 
   2 files : 
      BaseSystem.dmg and InstallESD.dmg   or a slight variant (InstallESDDmg.pkg).     
              
              On mac users never care about packaging or container since one just 
     click or double click on it and things appear crystal clear to play with.
        Unfortunately linux (and qemu of course) only interact well with raw image.    
      since dmg is a form of compressed block,one can use many ways on linux to convert to
      raw but ...with cares because 
      "the block compressed mac dmg" could be a stack of multi partitions...and fortunately
      until now mac leaves there only one partition under hfs !!!
       
     - once upon a time ,people looked for offset of partition beginning with hfs signature
         
     -  the most used conversion is dmg2img file.dmg file.img
         
     -  an eastern european proposed darling-dmg to mount directly the compressed hfs 
              partition allowing manipulation directly
         
     -  using the universal compress/uncompress 7z to unwield and get the hfs partition  
