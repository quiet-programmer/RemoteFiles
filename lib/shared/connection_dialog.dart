import 'package:flutter/material.dart';
import '../pages/pages.dart';
import '../services/services.dart';
import 'shared.dart';

class ConnectionDialog extends StatelessWidget {
  final BuildContext context;
  final int index;
  final String page;
  final IconData primaryButtonIconData;
  final String primaryButtonLabel;
  final GestureTapCallback primaryButtonOnPressed;
  final bool hasSecondaryButton;
  final IconData secondaryButtonIconData;
  final String secondaryButtonLabel;
  final GestureTapCallback secondaryButtonOnPressed;

  ConnectionDialog({
    @required this.context,
    this.index,
    @required this.page,
    @required this.primaryButtonIconData,
    @required this.primaryButtonLabel,
    @required this.primaryButtonOnPressed,
    this.hasSecondaryButton = false,
    this.secondaryButtonIconData,
    this.secondaryButtonLabel,
    this.secondaryButtonOnPressed,
  });

  void show() {
    customShowDialog(
      context: context,
      builder: (context) => this,
    );
  }

  Row _buildPasswordRow(int passwordLength) {
    if (passwordLength == 0) passwordLength = 1;
    List<Widget> widgets = [];
    for (int i = 0; i < passwordLength; i++) {
      widgets.add(
        Container(
          margin: EdgeInsets.only(top: 8.0, right: 4.0),
          width: 4.0,
          height: 4.0,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      );
    }
    return Row(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    Connection values = Connection();
    if (page == "favorites") {
      values = HomePage.favoritesPage.connections[index];
    } else if (page == "recentlyAdded") {
      values = HomePage.recentlyAddedPage.connections[index];
    } else if (page == "connection") {
      values = ConnectionPage.connection;
    }
    return CustomAlertDialog(
      title: Text(
        page == "connection" ? "Current connection" : (values.name != "" ? values.name : values.address),
        style: TextStyle(
          fontFamily: SettingsVariables.accentFont,
        ),
      ),
      content: Container(
        width: 400.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Opacity(
              opacity: .8,
              child: Table(
                columnWidths: {0: FixedColumnWidth(120.0)},
                children: [
                  page == "connection"
                      ? TableRow(children: [
                          Container(),
                          Container(),
                        ])
                      : TableRow(children: [
                          Text("Name:"),
                          Text(values.name != "" ? values.name : "-"),
                        ]),
                  TableRow(children: [
                    Text("Address:"),
                    Text(values.address),
                  ]),
                  TableRow(children: [
                    Text("Port:"),
                    Text(values.port),
                  ]),
                  TableRow(children: [
                    Text("Username:"),
                    Text(
                      values.username != "" ? values.username : "-",
                      style: TextStyle(),
                    )
                  ]),
                  TableRow(
                    children: [
                      Text("Password/Key:"),
                      values.passwordOrKey != "" ? _buildPasswordRow(values.passwordOrKey.length) : Text("-"),
                    ],
                  ),
                  TableRow(children: [
                    Text("Path:"),
                    Text(values.path),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        hasSecondaryButton
            ? FlatButton(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 3.5, bottom: 1.0),
                      child: Icon(
                        secondaryButtonIconData,
                        size: 19.0,
                      ),
                    ),
                    Text(secondaryButtonLabel),
                  ],
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                padding: EdgeInsets.only(top: 8.5, bottom: 8.0, left: 12.0, right: 14.0),
                onPressed: secondaryButtonOnPressed)
            : null,
        RaisedButton(
          color: Theme.of(context).accentColor,
          splashColor: Colors.black12,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 3.5, bottom: 1.0),
                child: Icon(
                  primaryButtonIconData,
                  size: 19.0,
                  color: Colors.white,
                ),
              ),
              Text(
                primaryButtonLabel,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          padding: EdgeInsets.only(top: 8.5, bottom: 8.0, left: 12.0, right: 14.0),
          elevation: .0,
          onPressed: primaryButtonOnPressed,
        ),
        SizedBox(width: .0),
      ],
    );
  }
}
