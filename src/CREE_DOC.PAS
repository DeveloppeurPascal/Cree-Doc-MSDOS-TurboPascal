{
Ce programme cree les documentations … partir de l'interface des unit‚s choisies.
}
Program Cree_Doc;             { mise … jour : 29 - 12 - 1990. }

uses olf_software,
     u_Sgf,
     u_Fenetre,
     Crt;

Const Num_Version  : String [3] = '1.3';
      Date_Version : String [10] = '28-12-1990';

Var Nom_Fich1,
    Nom_Fich2 : String;

Procedure Maj_Chaine (Chaine1 : String; Var Chaine2 : String);
Var I : Integer;
Begin { maj_chaine }
  For I := 1 To Length (Chaine1) Do
    Chaine2 [I] := Upcase (Chaine1 [I])
  {endfor};
  Chaine2 [0] := Chaine1 [0]
End; { maj_chaine }

procedure Presentation;
Var Choix : Char;
Begin { presentation }
  Type_Cadre := 2;
  Window_Cadre (2, 2, 78, 20, White);
  Textcolor (White);
  Textbackground (Black);
  Clrscr;
  Writeln ('                          Cree_Doc.            (V', Num_Version, ')');
  Writeln;
  Writeln ('› ', Date_Version, ' de Pr‚martin Patrick.');
  Writeln;
  Writeln ('   Ce programme prend la partie Interface de vos unit‚s et la transforme En');
  Writeln ('fichier texte d''extension .DOC, vous pourrez ainsi distribuer vos Unit‚S');
  Writeln ('sans donner le fichier source ni le listing.');
  Writeln;
  Writeln ('Attention: Ce programme arrŠte son travail dŠs qu''il trouve le mot:');
  Writeln ('           ''Implementation'' dans le code source de l''unit‚');
  Writeln ('           Faites-y gaffe...');
  Writeln;
  Writeln ('   Encore une chose, ce programme n''accepte que les fichiers d''extension');
  Writeln ('.PAS qui est prise par d‚faut (Inutile de la pr‚ciser)...');
  Writeln;
  Writeln ('   ce programme est en freeware, il ne peut ˆtre utilis‚ … des');
  Writeln ('fins commerciales sans l''accord de son auteur...');
  Writeln;
  Write   ('                    Appuyez sur une touche...');
  While (Keypressed) Do
    Choix := Readkey
  {endwhile};
  Choix := Readkey;
  Clear_Window
End; { presentation }

Procedure Ask_Fichier (Var Nom_Fich : String);
Begin { ask_fichier }
  Type_Cadre := 4;
  Window_Cadre (2, 2, 79, 3, White);
  Textcolor (Red);
  Repeat
    Clrscr;
    Writeln ('Nom du fichier dont vous voulez la doc:');
    Readln (Nom_Fich);
    Met_Extension (Nom_Fich, '.PAS', Nom_Fich)
  Until (Exist (Nom_Fich) And (Nom_Fich <> ''));
  Clear_Window
End; { ask_fichier }

Procedure Traitement (Fich1, Fich2 : String);
Var Fichier1, Fichier2 : Text;
    Chaine1, Chaine2   : String;
    Posit, Ligne       : Integer;
Begin { traitement }
  Type_Cadre := 2;
  Window_Cadre (10, 10, 30, 11, Green);
  Textcolor (Blue);
  Clrscr;
  Writeln ('Traitement en cours.');
  Assign (Fichier1, Fich1);
  Reset (Fichier1);
  Assign (Fichier2, Fich2);
  Rewrite (Fichier2);
  Ligne := 0;
  Posit := 0;
  While Not (Eof (Fichier1) Or (Posit <> 0)) Do
    Begin
      Inc (Ligne);
      Gotoxy (1, 2);
      Clreol;
      Write ('Ligne: ',Ligne : 13);
      Readln (Fichier1, Chaine1);
      Maj_Chaine (Chaine1, Chaine2);
      Posit := Pos ('IMPLEMENTATION', Chaine2);
      If (Posit <> 0)
      Then
        Writeln (Fichier2, '{ Fin de la documentation de ', Fich2, ' }')
      Else
        Writeln (Fichier2, Chaine1)
      {endif}
    End
  {endwhile};
  Close (Fichier1);
  Close (Fichier2);
  Clear_Window
End; { traitement }

Function Ask_Autre : Boolean;
Var Choix : Char;
Begin { ask_autre }
  Type_Cadre := 1;
  Window_Cadre (2, 10, 79, 10, Green);
  Textcolor (Lightgray);
  Clrscr;
  Write ('Voulez-vous faire une autre doc ?');
  Repeat
    Choix := Upcase (Readkey)
  Until ((Choix = 'O') Or (Choix = 'N'));
  Ask_Autre := (Choix = 'O');
  Clear_Window
End; { ask_autre }

Begin { cree_doc }
      init_olf_message (mess_freeware);
      init_licence ('CRDO');
      init_olf_software ('Cree Doc v'+num_version, #155' Patrick Pr‚martin '+date_version);
  Window (1, 1, 80, 25);
  Textcolor (Lightgray);
  Textbackground (Black);
  Clrscr;
  Presentation;
  Repeat
    Ask_Fichier (Nom_Fich1);
    Maj_Chaine (Nom_Fich1, Nom_Fich1);
    Met_Extension (Nom_Fich1, '.DOC', Nom_Fich2);
    Traitement (Nom_Fich1, Nom_Fich2)
  Until (Not Ask_Autre);
  Window (1, 1, 80, 25);
  Textcolor (Lightgray);
  Textbackground (Black);
  Clrscr
End. { cree_doc }
