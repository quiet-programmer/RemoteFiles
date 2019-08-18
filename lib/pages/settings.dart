import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'pages.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class SettingsPage extends StatefulWidget {
  final ConnectionPage currentConnectionPage;

  SettingsPage({this.currentConnectionPage});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  Widget _buildHeadline(
    String title, {
    bool hasSwitch = false,
    Function onChanged,
  }) {
    String sortLabel;
    if (hasSwitch) {
      if (SettingsVariables.sort == "name") {
        if (SettingsVariables.sortIsDescending) {
          sortLabel = "(A-Z)";
        } else {
          sortLabel = "(Z-A)";
        }
      } else {
        if (SettingsVariables.sortIsDescending) {
          sortLabel = "(New-Old)";
        } else {
          sortLabel = "(Old-New)";
        }
      }
    }
    return Padding(
      padding: EdgeInsets.only(
        top: hasSwitch ? 8 : 19,
        bottom: hasSwitch ? 0 : 11,
        left: 18,
        right: 18,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
              letterSpacing: 1.0,
              color: Theme.of(context).hintColor,
            ),
          ),
          hasSwitch
              ? Row(
                  children: <Widget>[
                    Text(
                      sortLabel.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                        letterSpacing: 1.0,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    SizedBox(width: 6.0),
                    Switch(
                      activeThumbImage:
                          AssetImage("assets/arrow_drop_down.png"),
                      activeColor: Provider.of<CustomTheme>(context)
                              .isLightTheme(context)
                          ? Colors.grey[50]
                          : Colors.grey[400],
                      activeTrackColor: Provider.of<CustomTheme>(context)
                              .isLightTheme(context)
                          ? Colors.grey[300]
                          : Colors.grey[700],
                      inactiveThumbImage:
                          AssetImage("assets/arrow_drop_up.png"),
                      inactiveTrackColor: Provider.of<CustomTheme>(context)
                              .isLightTheme(context)
                          ? Colors.grey[300]
                          : Colors.grey[700],
                      inactiveThumbColor: Provider.of<CustomTheme>(context)
                              .isLightTheme(context)
                          ? Colors.grey[50]
                          : Colors.grey[400],
                      value: SettingsVariables.sortIsDescending,
                      onChanged: onChanged,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildRadioListTile({
    @required String titleLabel,
    @required String value,
    @required bool isView,
  }) {
    return RadioListTile(
      activeColor: Theme.of(context).accentColor,
      title: Text(titleLabel),
      groupValue: isView ? SettingsVariables.view : SettingsVariables.sort,
      value: value,
      onChanged: (String radioValue) async {
        if (isView) {
          await SettingsVariables.setView(value);
        } else {
          await SettingsVariables.setSort(value);
          if (widget.currentConnectionPage != null) {
            widget.currentConnectionPage.sortFileInfos();
          }
        }
        setState(() {});
      },
    );
  }

  Widget _buildSaveToWidget() {
    if (Platform.isIOS) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),
          _buildHeadline("Save files to:"),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 19.0,
              vertical: 4.0,
            ),
            child: Container(
              child: TextField(
                controller: _downloadPathTextController,
                decoration: InputDecoration(
                  labelText: "Path",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomTooltip(
                        message: "Clear",
                        child: CustomIconButton(
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            SettingsVariables.setDownloadDirectory("").then(
                                (_) => _downloadPathTextController.text = "");
                          },
                        ),
                      ),
                      CustomTooltip(
                        message: "Set to default",
                        child: CustomIconButton(
                          icon: Icon(
                            Icons.settings_backup_restore,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            SettingsVariables.setDownloadDirectoryToDefault()
                                .then((Directory dir) {
                              _downloadPathTextController.text = dir.path;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                onChanged: (String value) async {
                  await SettingsVariables.setDownloadDirectory(value);
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  var _downloadPathTextController =
      TextEditingController(text: SettingsVariables.downloadDirectory.path);

  var _moveCommandTextController =
      TextEditingController(text: SettingsVariables.moveCommand);
  var _copyCommandTextController =
      TextEditingController(text: SettingsVariables.copyCommand);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        leading: Padding(
          padding: EdgeInsets.all(7),
          child: CustomIconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text("Settings", style: TextStyle(fontSize: 19)),
        titleSpacing: 4,
        elevation: 2,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: Scrollbar(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(height: 4),
                _buildHeadline("View"),
                _buildRadioListTile(
                  titleLabel: "List",
                  value: "list",
                  isView: true,
                ),
                _buildRadioListTile(
                  titleLabel: "Detailed",
                  value: "detailed",
                  isView: true,
                ),
                _buildRadioListTile(
                  titleLabel: "Grid",
                  value: "grid",
                  isView: true,
                ),
                Divider(),
                _buildHeadline(
                  "Sort",
                  hasSwitch: true,
                  onChanged: (bool value) async {
                    await SettingsVariables.setSortIsDescending(value);
                    if (widget.currentConnectionPage != null) {
                      widget.currentConnectionPage.sortFileInfos();
                    }
                    setState(() {});
                  },
                ),
                _buildRadioListTile(
                  titleLabel: "Name",
                  value: "name",
                  isView: false,
                ),
                _buildRadioListTile(
                  titleLabel: "Modification Date",
                  value: "modificationDate",
                  isView: false,
                ),
                _buildRadioListTile(
                  titleLabel: "Last Access",
                  value: "lastAccess",
                  isView: false,
                ),
                Divider(),
                _buildHeadline("Appearance"),
                ListTile(
                  title: Text("Theme"),
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Opacity(
                      opacity: .6,
                      child: Text(Provider.of<CustomTheme>(context)
                              .themeValue[0]
                              .toUpperCase() +
                          Provider.of<CustomTheme>(context)
                              .themeValue
                              .substring(1)),
                    ),
                  ),
                  onTap: () {
                    customShowDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        content: StatefulBuilder(builder: (context, setState) {
                          return Consumer<CustomTheme>(
                              builder: (context, model, child) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                RadioListTile(
                                  activeColor: Theme.of(context).accentColor,
                                  title: Text("Automatic"),
                                  value: "automatic",
                                  groupValue: model.themeValue,
                                  onChanged: (String value) async {
                                    await model.setThemeValue(value);
                                    setState(() {});
                                  },
                                ),
                                RadioListTile(
                                  activeColor: Theme.of(context).accentColor,
                                  title: Text("Light"),
                                  value: "light",
                                  groupValue: model.themeValue,
                                  onChanged: (String value) async {
                                    await model.setThemeValue(value);
                                    setState(() {});
                                  },
                                ),
                                RadioListTile(
                                  activeColor: Theme.of(context).accentColor,
                                  title: Text("Dark"),
                                  value: "dark",
                                  groupValue: model.themeValue,
                                  onChanged: (String value) async {
                                    await model.setThemeValue(value);
                                    setState(() {});
                                  },
                                ),
                              ],
                            );
                          });
                        }),
                      ),
                    );
                  },
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).accentColor,
                  title: Text("AMOLED Dark Theme"),
                  value: SettingsVariables.useAmoledDarkTheme,
                  onChanged: (bool value) async {
                    await SettingsVariables.setUseAmoledDarkTheme(value);
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).accentColor,
                  title: Text("Show hidden files"),
                  value: SettingsVariables.showHiddenFiles,
                  onChanged: (bool value) async {
                    await SettingsVariables.setShowHiddenFiles(value);
                    setState(() {});
                  },
                ),
                ListTile(
                  title: Text("Unit for filesize"),
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Opacity(
                      opacity: .6,
                      child: Text(
                          SettingsVariables.filesizeUnit[0].toUpperCase() +
                              SettingsVariables.filesizeUnit.substring(1)),
                    ),
                  ),
                  onTap: () {
                    customShowDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        content: StatefulBuilder(builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("Automatic"),
                                value: "automatic",
                                groupValue: SettingsVariables.filesizeUnit,
                                onChanged: (String value) async {
                                  await SettingsVariables.setFilesizeUnit(
                                      value, widget.currentConnectionPage);
                                  setState(() {});
                                },
                              ),
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("Byte"),
                                value: "B",
                                groupValue: SettingsVariables.filesizeUnit,
                                onChanged: (String value) async {
                                  await SettingsVariables.setFilesizeUnit(
                                      value, widget.currentConnectionPage);
                                  setState(() {});
                                },
                              ),
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("Kilobyte"),
                                value: "KB",
                                groupValue: SettingsVariables.filesizeUnit,
                                onChanged: (String value) async {
                                  await SettingsVariables.setFilesizeUnit(
                                      value, widget.currentConnectionPage);
                                  setState(() {});
                                },
                              ),
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("Megabyte"),
                                value: "MB",
                                groupValue: SettingsVariables.filesizeUnit,
                                onChanged: (String value) async {
                                  await SettingsVariables.setFilesizeUnit(
                                      value, widget.currentConnectionPage);
                                  setState(() {});
                                },
                              ),
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("Gigabyte"),
                                value: "GB",
                                groupValue: SettingsVariables.filesizeUnit,
                                onChanged: (String value) async {
                                  await SettingsVariables.setFilesizeUnit(
                                      value, widget.currentConnectionPage);
                                  setState(() {});
                                },
                              ),
                            ],
                          );
                        }),
                      ),
                    );
                  },
                ),
                Divider(),
                _buildHeadline("Shell commands"),
                ListTile(
                  title: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth / 2.8,
                            ),
                            child: Text("Moving files:"),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _moveCommandTextController,
                              decoration: InputDecoration(
                                suffixIcon: CustomTooltip(
                                  message: "Set to default",
                                  child: CustomIconButton(
                                    icon: Icon(
                                      Icons.settings_backup_restore,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    onPressed: () {
                                      SettingsVariables
                                              .setMoveCommandToDefault()
                                          .then((String command) {
                                        _moveCommandTextController.text =
                                            command;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              onChanged: (String value) async {
                                await SettingsVariables.setMoveCommand(value);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                ListTile(
                  title: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth / 2.8,
                            ),
                            child: Text("Copying files:"),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _copyCommandTextController,
                              decoration: InputDecoration(
                                suffixIcon: CustomTooltip(
                                  message: "Set to default",
                                  child: CustomIconButton(
                                    icon: Icon(
                                      Icons.settings_backup_restore,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    onPressed: () {
                                      SettingsVariables
                                              .setCopyCommandToDefault()
                                          .then((String command) {
                                        _copyCommandTextController.text =
                                            command;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              onChanged: (String value) async {
                                await SettingsVariables.setCopyCommand(value);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _buildSaveToWidget(),
                Divider(),
                _buildHeadline("Other"),
                ListTile(
                  title: Text("Delete all connections"),
                  onTap: () {
                    customShowDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        title: Text(
                          "Delete all connections?\nThis cannot be undone.",
                        ),
                        actions: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            padding: EdgeInsets.only(
                                top: 8.5, bottom: 8.0, left: 14.0, right: 14.0),
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            color: Theme.of(context).accentColor,
                            splashColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            padding: EdgeInsets.only(
                                top: 8.5, bottom: 8.0, left: 14.0, right: 14.0),
                            child: Text(
                              "OK",
                              style: TextStyle(
                                color: Provider.of<CustomTheme>(context)
                                        .isLightTheme(context)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            elevation: .0,
                            onPressed: () {
                              HomePage.favoritesPage.removeAllFromJson();
                              HomePage.favoritesPage.setConnectionsFromJson();
                              HomePage.recentlyAddedPage.removeAllFromJson();
                              HomePage.recentlyAddedPage
                                  .setConnectionsFromJson();
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: .0),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
