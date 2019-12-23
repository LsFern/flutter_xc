import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
      this.enabled,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _genNormal
        : _genNorHome;
  }

  Widget get _genNormal {
    return Container(
        padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
        child: Row(children: <Widget>[
          _wrapTap(
              Container(
                child: widget?.hideLeft ?? false
                    ? null
                    : Icon(
                        Icons.arrow_back_ios,
                        size: 26,
                        color: Colors.grey,
                      ),
              ),
              widget.leftButtonClick),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  '搜索',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
              widget.rightButtonClick)
        ]));
  }

  Widget get _genNorHome {
    return Container(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        child: Row(children: <Widget>[
          _wrapTap(
              Container(
                  padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '上海',
                        style: TextStyle(color: _homeFontColor(), fontSize: 14),
                      ),
                      Icon(
                        Icons.expand_more,
                        color: _homeFontColor(),
                        size: 22,
                      )
                    ],
                  )),
              widget.leftButtonClick),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
              Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Icon(
                    Icons.comment,
                    size: 26,
                    color: _homeFontColor(),
                  )),
              widget.rightButtonClick)
        ]));
  }

  _inputBox() {
    Color inputColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputColor = Colors.white;
    } else {
      inputColor = Color(0xffEDEDED);
    }
    return Container(
        height: 30,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
            color: inputColor,
            borderRadius: BorderRadius.circular(
                widget.searchBarType == SearchBarType.normal ? 5 : 15)),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search,
              size: 20,
              color: widget.searchBarType == SearchBarType.normal
                  ? Color(0xffA9A9A9)
                  : Colors.blue,
            ),
            Expanded(
                flex: 1,
                child: widget.searchBarType == SearchBarType.normal
                    ? TextField(
                        controller: _controller,
                        onChanged: _onTextChanged,
                        autofocus: true,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            border: InputBorder.none,
                            hintText: widget.hint ?? '',
                            hintStyle: TextStyle(fontSize: 15)),
                      )
                    : _wrapTap(
                        Container(
                          child: Text(
                            widget.defaultText,
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ),
                        widget.inputBoxClick)),
            !showClear
                ? _wrapTap(
                    Icon(
                      Icons.mic,
                      size: 22,
                      color: widget.searchBarType == SearchBarType.normal
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    widget.speakClick)
                : _wrapTap(
                    Icon(
                      Icons.clear,
                      size: 22,
                      color: Colors.grey,
                    ), () {
                    setState(() {
                      _controller.clear();
                    });
                    _onTextChanged('');
                  })
          ],
        ));
  }

  _onTextChanged(String text) {
    setState(() {
      showClear = text.length > 0;
    });
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  _wrapTap(Widget child, void Function() callBack) {
    return GestureDetector(
      onTap: () {
        if (callBack != null) callBack();
      },
      child: child,
    );
  }

  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }
}
