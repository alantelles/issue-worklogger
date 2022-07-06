procedure BindText(Edit: TEdit; Button: TButton; Group: TGroupBox);
var
  colonPos: integer;
begin
  CheckDisablement(Button);
  Edit.Text := Trim(Edit.Text);
  colonPos := Pos(';', Edit.Text);
  if (colonPos = 1) then
  begin
    Button.Caption := Copy(Edit.Text, 1, 1);
    Group.Caption := Copy(Edit.Text, colonPos + 1, Length(Edit.Text));
  end
  else if Edit.Text = '' then
  begin
    Button.Enabled := True;
    Button.Caption := DISABLED_TRIGGER_TEXT;
    Group.Caption := DISABLED_TRIGGER_TEXT;
  end
  else if (colonPos = Length(Edit.Text)) then
  begin
    Button.Caption := Copy(Edit.Text, 1, colonPos-1);
    Group.Caption := Copy(Edit.Text, 1, colonPos-1);
  end
  else if (colonPos > 0) then
  begin
    Button.Caption := Copy(Edit.Text, 1, colonPos - 1);
    Group.Caption := Copy(Edit.Text, colonPos + 1, Length(Edit.Text));
  end
  else
  begin
    Button.Caption := Edit.Text;
    Group.Caption := Edit.Text;
  end;
  CheckDisablement(Button);
  TFileSaveService.SaveTriggers(Edit.Name, Edit.Text);
end;

procedure TForm1.TxtTrigger1Change(Sender: TObject);
begin
  BindText(TxtTrigger1, BtnTrigger1, GrpTrigger1);
end;

procedure TForm1.TxtTrigger2Change(Sender: TObject);
begin
  BindText(TxtTrigger2, BtnTrigger2, GrpTrigger2);
end;

procedure TForm1.TxtTrigger3Change(Sender: TObject);
begin
  BindText(TxtTrigger3, BtnTrigger3, GrpTrigger3);
end;

procedure TForm1.TxtTrigger4Change(Sender: TObject);
begin
  BindText(TxtTrigger4, BtnTrigger4, GrpTrigger4);
end;

procedure TForm1.TxtTrigger5Change(Sender: TObject);
begin
  BindText(TxtTrigger5, BtnTrigger5, GrpTrigger5);
end;

procedure TForm1.TxtTrigger6Change(Sender: TObject);
begin
  BindText(TxtTrigger6, BtnTrigger6, GrpTrigger6);
end;

procedure TForm1.TxtTrigger7Change(Sender: TObject);
begin
  BindText(TxtTrigger7, BtnTrigger7, GrpTrigger7);
end;

procedure TForm1.TxtTrigger8Change(Sender: TObject);
begin
  BindText(TxtTrigger8, BtnTrigger8, GrpTrigger8);
end;

procedure TForm1.TxtTrigger9Change(Sender: TObject);
begin
  BindText(TxtTrigger9, BtnTrigger9, GrpTrigger9);
end;

procedure TForm1.TxtTrigger10Change(Sender: TObject);
begin
  BindText(TxtTrigger10, BtnTrigger10, GrpTrigger10);
end;
