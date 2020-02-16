'USEUNIT Db
'USEUNIT DBTables
'USEUNIT Menus
'USEUNIT ExtCtrls
'USEUNIT DBCtrls
'USEUNIT DBGrids
'USEUNIT ComCtrls
'USEUNIT Buttons
'USEUNIT StdCtrls
'USEUNIT About
'USEUNIT Filter1

dim  OrdersFilterAmount

'-------------------------------------------------------------------

sub rgDataSetClick(Sender)
  st=""
  if (CustomerSource.Dataset.Filtered) then st = CustomerSource.Dataset.Filter
  select case (rgDataset.ItemIndex)
    case 0:  CustomerSource.Dataset = SQLCustomer
    case 1:  CustomerSource.Dataset = Customer
  end select
  if st <> "" then
    CustomerSource.Dataset.Filter = st
    CustomerSource.Dataset.Filtered = true
  End If
End Sub

'-------------------------------------------------------------------

sub SpeedButton1Click(Sender)
  fmFilterFrm.Show
End Sub

'-------------------------------------------------------------------

sub cbFilterOrdersClick(Sender)
  SQLOrders.Filtered = cbFilterOrders.Checked
  if (cbFilterOrders.Checked) then  Edit1Change(NULL)
End Sub

'-------------------------------------------------------------------

sub About1Click(Sender)
  Formabout.ShowModal
End Sub

'-------------------------------------------------------------------

sub Edit1Change(Sender)
  if (cbFilterOrders.checked) and ( Edit1.Text <> "") then
    OrdersFilterAmount = StrToFloat(fmCustView.Edit1.Text)
    SQLOrders.Filter = "AmountPaid >="+ fmCustView.Edit1.Text
    SQLOrders.Refresh
  End If
End Sub

'-------------------------------------------------------------------

sub DBGrid1Enter(Sender)
  DBNavigator1.DataSource = DBGrid1.DataSource
End Sub

'-------------------------------------------------------------------

sub DBGrid2Enter(Sender)
  DBNavigator1.DataSource = DBGrid2.DataSource
End Sub