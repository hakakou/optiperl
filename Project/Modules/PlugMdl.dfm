object PlugMod: TPlugMod
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 795
  Top = 431
  Height = 133
  Width = 163
  object ActionList: TActionList
    Images = CentralImageListMod.ImageList
    Left = 24
    Top = 24
    object UpdatePluginAction: THKAction
      Category = 'Plug-Ins'
      Caption = 'Update Plug-Ins'
      Hint = 'Update menu with new && updated plug-ins'
      ImageIndex = 59
      OnExecute = UpdatePluginActionExecute
      UserData = 0
    end
  end
end
