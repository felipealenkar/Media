unit UnitMedia;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.BaseImageCollection,
  Vcl.ImageCollection, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList,
  Vcl.StdCtrls, Vcl.VirtualImage, Vcl.Themes, Vcl.Styles, Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TFormMedia = class(TForm)
    IcMedia: TImageCollection;
    VilMedia: TVirtualImageList;
    EditNota1: TEdit;
    LabelExplicacao: TLabel;
    LabelNota1: TLabel;
    LabelNota2: TLabel;
    EditNota2: TEdit;
    LabelNota3: TLabel;
    EditNota3: TEdit;
    VirtualImage1: TVirtualImage;
    LabelTextoMedia: TLabel;
    LabelMedia: TLabel;
    LabelResultado: TLabel;
    SpeedButtonCalcular: TSpeedButton;
    procedure SpeedButtonCalcularClick(Sender: TObject);

    procedure EditNotaChange(Sender: TObject);
    procedure EditNotaEnter(Sender: TObject);
    procedure EditNotaExit(Sender: TObject);
  private
    Var Nota1, Nota2, Nota3: Double;
    function ValidarVazio(PVlNota: String):Boolean;
    function ValidarNota(PVlNota: String): Boolean;
    procedure AlimentarNota(Sender: TObject; PVlNota: Double);
    procedure FormataEdit(Sender: TObject);
    function CalcularMedia(PNota1, PNota2, PNota3: Double): Double;
    procedure ExibirResultados(PMedia: Double);
    { Private declarations }
  public

    { Public declarations }
  end;

var
  FormMedia: TFormMedia;

implementation

{$R *.dfm}

function TFormMedia.ValidarVazio(PVlNota: String): Boolean;
//Valida se PVlNota está vazio
begin
  Result := PVlNota = '';
end;

function TFormMedia.ValidarNota(PVlNota: String): Boolean;
//Valida se PVlNota é válida
Var
  PVlNotaValidada: Double;
begin
  Try
    PVlNotaValidada := StrToFloat(PVlNota);
    result := ((PVlNotaValidada >= 0) and (PVlNotaValidada <= 10));
  Except
    Result := False;
  end;
  if Result = False then
  begin
    Showmessage('Você digitou ' + PVlNota + ', digite uma nota válida entre 0 e 10');
  end;
end;

procedure TFormMedia.AlimentarNota(Sender: TObject; PVlNota: Double);
//Alimenta minhas variáveis de nota com o conteúdo do edit passado
begin
  if TEdit(Sender).Name = 'EditNota1' then
    Nota1 := Trunc(PVlNota * 100) / 100
  else if TEdit(Sender).Name = 'EditNota2' then
    Nota2 := Trunc(PVlNota * 100) / 100
  else if TEdit(Sender).Name = 'EditNota3' then
    Nota3 := Trunc(PVlNota * 100) / 100;
end;

function TFormMedia.CalcularMedia(PNota1, PNota2, PNota3: Double): Double;
//Função que calcula a média
begin
  Result := (PNota1 + PNota2 + PNota3) / 3;
end;

procedure TFormMedia.ExibirResultados(PMedia: Double);
//Exibe os resultados nos edits, a média e se o aluno foi aprovado
begin
  LabelMedia.Caption := FormatFloat('0.00', PMedia);
  if PMedia >= 7 then
  begin
    LabelResultado.Visible := True;
    LabelResultado.Font.Color := clGreen;
    LabelResultado.Caption := 'O aluno foi aprovado';
  end
  else if PMedia >= 5 then
  begin
    LabelResultado.Visible := True;
    LabelResultado.Font.Color := RGB(255, 148, 40);
    LabelResultado.Caption := 'O aluno está em recuperação';
  end
  else
  begin
    LabelResultado.Visible := True;
    LabelResultado.Font.Color := ClRed;
    LabelResultado.Caption := 'O aluno foi reprovado';
    end;
end;

procedure TFormMedia.FormataEdit(Sender: TObject);
begin
  if not ValidarVazio(TEdit(Sender).Text) then
  begin
    if TEdit(Sender).Name = 'EditNota1' then
      TEdit(Sender).Text := Nota1.ToString
    else if TEdit(Sender).Name = 'EditNota2' then
      TEdit(Sender).Text := Nota2.ToString
    else if TEdit(Sender).Name = 'EditNota3' then
      TEdit(Sender).Text := Nota3.ToString;
  end;

end;

procedure TFormMedia.EditNotaEnter(Sender: TObject);
//Evento OnEnter personalizado, para usar em todos os Edits
begin
  TEdit(Sender).Color := clCream;
end;

procedure TFormMedia.EditNotaExit(Sender: TObject);
//Evento OnExit personalizado, para usar em todos os Edits
begin
  TEdit(Sender).Color := clWindow;
  FormataEdit(TEdit(Sender));
end;

procedure TFormMedia.EditNotaChange(Sender: TObject);
//Evento OnChange personalizado, para usar em todos os Edits
begin
  if not ValidarVazio(TEdit(Sender).Text) then
  begin
    if ValidarNota(TEdit(Sender).Text) then
      AlimentarNota(TEdit(Sender), StrToFloat(TEdit(Sender).Text))
    else
      TEdit(Sender).Clear;
  end;
end;

procedure TFormMedia.SpeedButtonCalcularClick(Sender: TObject);
Var
  Media: Double;
begin
  if (ValidarVazio(EditNota1.Text)) or (ValidarVazio(EditNota2.Text)) or (ValidarVazio(EditNota3.Text)) then
    Showmessage('Ainda tem notas não preenchidas, para poder calcular a média é necessário preencher as 3 notas.')
  else
  begin
    Media := Trunc(CalcularMedia(Nota1, Nota2, Nota3) * 100) / 100;
    ExibirResultados(Media);
  end;
end;

end.
