
// The packages must be rebuilt to make the changes in this file active

// -----------------------------------------------------------------------------

// All the VSTools units depends on short-circuit boolean evaluation

{$BOOLEVAL OFF} 


// -----------------------------------------------------------------------------

// 64 Bit Windows does not allow for code execution in anything other than virtual address space.
// VSTools uses a stub allocation to make a object method a windows callback through assembly
// code.  If using a replacement memory manager that does not use memory that is execuable in
// 64 bit windows, or if future Delphi memory managers change and allocate memory that is not
// executable in 64 bit Windows uncomment the following define.  This will force the stub
// code to allocate virtual memory on it own.  The drawback is it allocates it in 64k blocks but
// 64k in Win64 should be nothing.....

{.$DEFINE VIRTUALMEMSTUB}





// -----------------------------------------------------------------------------

// Use the following to try to reduce the size of a VET project if indicated
// features are not needed.

{$DEFINE SHELLNOTIFIER}       // Shell notifer threads
{$DEFINE THREADEDICONS}       // Image icon threads
{$DEFINE EXPLORERCOMBOBOX}    // ExplorerCombobox
{$DEFINE PERSISTENTSTORAGE}   // The persistent storage of VET, used to refresh tree to previous state








// -----------------------------------------------------------------------------
//  VIRTUAL NAMESPACE SUPPORT
//
// Use the following conditional define if you want to include the ability
// to use Virtual (Custom) Namespaces in VET.  The the Doc/VirtualNamespace folder for
// an explination as to what VirtualNamespaces are

//{$DEFINE VIRTUALNAMESPACES}







// -----------------------------------------------------------------------------
//
//  GRAPHICEX SUPPORT
//
// If you are using Mike Lischke's GraphicEx package to extend the thumbnails
// In VirtualExplorerListviewEx then uncomment this line to automatically link
// GraphicEx into the VirtualExplorerListviewEx

//{$DEFINE USEGRAPHICEX}


// The following are the registerable types supported by GraphicEx, see the
// GraphicConfiguration.inc file in GraphicEx to enable or disable types.
//  NOTE:
//      To enable GIF you must change
//          {.$define UseLZW}
//      to
//          {$define UseLZW}
// in GraphicConfiguration.inc
//
//        TargaGraphic                  // *.win, *.vst, *.vda, *.tga, *.icb
//        TIFFGraphic                   // *.tiff, *.tif, *.fax
//        EPSGraphic                    // *.eps
//        PCXGraphic                    // *.pcx, *.pcc, *.scr
//        RLAGraphic                    // *.rpf, *.rla
//        SGIGraphic                    // *.sgi, *.rgba, *.rgb, *.bw
//        PhotoshopGraphic              // *.psd, *.pdd
//        PortableMapGraphic            // *.ppm, *.pgm, *.pbm
//        AutodeskGraphic               // *.cel, *.pic
//        PCDGraphic                    // *.pcd, *.pic
//        GIFGraphic                    // *.gif
//        CUTGraphic                    // *.cut
//        PaintshopProGraphic           // *.psp
//        PortableNetworkGraphic        // *.png

// -----------------------------------------------------------------------------
//
//  ImageEn SUPPORT
//
// If you are using HiComponents ImageEn package to extend the thumbnails
// in VirtualExplorerListviewEx then uncomment this line to automatically link
// ImageEn into the VirtualExplorerListviewEx.
// WARNING. You will need an LZW patent license from Unisys in order to provide
// end-user GIF support legally in your application.
// To support GIF and TIFF images you'll have to add GifLZW and TIFLZW units in
// your application, and set a few global variables in your Form.OnCreate event:
// DefGIF_LZWDECOMPFUNC := GIFLZWDecompress;
// DefGIF_LZWCOMPFUNC := GIFLZWCompress;
// DefTIFF_LZWDECOMPFUNC := TIFFLZWDecompress;
// DefTIFF_LZWCOMPFUNC := TIFFLZWCompress;
// For more information read the ImageEn help file.

//{$DEFINE USEIMAGEEN}


// -----------------------------------------------------------------------------
//
//  ENVISION IMAGE LIBRARY SUPPORT
//
// If you are using Interval Software Envision Image Library package to extend the thumbnails
// in VirtualExplorerListviewEx then uncomment this line to automatically link
// Envision Image Library into the VirtualExplorerListviewEx.

//{$DEFINE USEENVISION}


// -----------------------------------------------------------------------------
//
//  IMAGEMAGICK
//
// If you are using ImageMagick to extend the thumbnails
// in VirtualExplorerListviewEx then uncomment this line to automatically link
// ImageMagick into the VirtualExplorerListviewEx.

//{$DEFINE USEIMAGEMAGICK}







// -----------------------------------------------------------------------------
// TOOLBAR 2000 and TBX SUPPORT FOR VIRTUALSHELLHISTORY MENU
// -----------------------------------------------------------------------------
//
// Uncomment out the conditional define for Toolbar 2000 and TBX Toolbar support
//
// WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING:
//
// You must either add the Tooolbar 2000 and/or the TBX packages to the
// VirtualShellToolsDx.dpk "Requires" section. Usually tbx_d5.dcp and tb2k_d5.dcp and
// TBXSwitcherItem_d5 if using the TBX addon theme switch for D5
// This is easier if you open the VirtualShellToolsDx.dpk with a text editor and add this:
//
// requires
//   vcl50,
//   VirtualTreesD5,
//   VirtualToolsCommonD5,
//   ThemeManager5,
//   tb2k_d5,
//   tbx_d5;
//
// For D6 replace with:
//
//  requires
//    VirtualTreesD6,
//    VirtualToolsCommonD6,
//    ThemeManager6
//    tb2k_d6,
//    tbx_d6;
//
// Then recompile VSTools
//
// DO NOT allow Delphi to add the units to the "Contains" section automaticlly
// if you forget to add the packages to the "Requires"
// section.

// Define USE_TOOLBAR_TB2K if you use Toolbar 2000, TBX or SpTBXLib
//
// {$DEFINE USE_TOOLBAR_TB2K}

