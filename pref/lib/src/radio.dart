// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';

class PrefRadio<T> extends StatefulWidget {
  const PrefRadio({
    this.title,
    @required this.value,
    @required this.pref,
    Key key,
    this.subtitle,
    this.selected = false,
    this.ignoreTileTap = false,
    this.onSelect,
    this.disabled = false,
    this.leading,
  })  : assert(value != null),
        assert(pref != null),
        super(key: key);

  final Widget title;

  final Widget subtitle;

  final T value;

  final String pref;

  final bool selected;

  final Function onSelect;

  final bool ignoreTileTap;

  final bool disabled;

  final Widget leading;

  @override
  _PrefRadioState createState() => _PrefRadioState<T>();
}

class _PrefRadioState<T> extends State<PrefRadio<T>> {
  @override
  void didChangeDependencies() {
    PrefService.of(context).addKeyListener(widget.pref, _onNotify);
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    PrefService.of(context).removeKeyListener(widget.pref, _onNotify);
    super.deactivate();
  }

  @override
  void reassemble() {
    PrefService.of(context).addKeyListener(widget.pref, _onNotify);
    super.reassemble();
  }

  void _onNotify() {
    setState(() {});
  }

  void _onChange(T value) {
    PrefService.of(context).set(widget.pref, value);

    if (widget.onSelect != null) {
      widget.onSelect();
    }
  }

  @override
  Widget build(BuildContext context) {
    T value;
    try {
      value = PrefService.of(context).get(widget.pref);
    } catch (e) {
      print('Unable to load the value: $e');
    }

    return ListTile(
      title: widget.title,
      leading: widget.leading,
      subtitle: widget.subtitle,
      trailing: Radio<T>(
        value: widget.value,
        groupValue: value,
        onChanged: widget.disabled ? null : (T val) => _onChange(widget.value),
      ),
      onTap: (widget.ignoreTileTap || widget.disabled)
          ? null
          : () => _onChange(widget.value),
    );
  }
}
