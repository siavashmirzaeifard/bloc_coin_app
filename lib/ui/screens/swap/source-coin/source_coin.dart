import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/swap-coin/swap_coin_bloc.dart';
import '../../../../constant/extension/extension.dart';
import '../../../../models/coin/coin.dart';
import '../../../widget/common_widgets.dart';

class Sourcecoin extends StatefulWidget {
  const Sourcecoin(
      {required this.coinList,
      required this.coin,
      required this.priceValue,
      required this.amount,
      Key? key})
      : super(key: key);
  final List<Coin> coinList;
  final Coin? coin;
  final double priceValue;
  final double amount;

  @override
  State<Sourcecoin> createState() => _SourcecoinState();
}

class _SourcecoinState extends State<Sourcecoin> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.amount.toString());

  late String _value = widget.coin?.id ?? 'bitcoin';

  late double _amount = widget.amount;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          topInfoWidgets(),
          SizedBox(height: size.height * 0.01),
          mainWidegets(),
        ],
      ),
    );
  }

  Row topInfoWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'I have ${_amount.toString()} ${_value.capitalize}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          '\$' + widget.priceValue.divideWithComma,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Row mainWidegets() {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CommonWidgets(imageUrl: widget.coin?.image).coinImage,
            SizedBox(width: width * 0.02),
            dropDownButton(),
          ],
        ),
        SizedBox(
          width: width * 0.3,
          child: amountTextField(),
        ),
      ],
    );
  }

  Widget dropDownButton() {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton(
        value: _value,
        items: CommonWidgets().getDropDownMenuItems(widget.coinList),
        onChanged: onChangedCoin,
        icon: const Icon(Icons.arrow_drop_down),
        isExpanded: true,
        borderRadius: BorderRadius.circular(15),
        dropdownColor: Colors.grey[100],
      ),
    );
  }

  TextField amountTextField() {
    return TextField(
      controller: _controller,
      onChanged: onChangedAmount,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.end,
      decoration: const InputDecoration(
        hintText: '0.00',
        hintStyle: TextStyle(
          fontSize: 17,
          color: Colors.grey,
        ),
        border: InputBorder.none,
      ),
    );
  }

  void onChangedCoin(String? value) {

    setState(() {
      _value = value!;
    });
    updateBloc();
  }

  void onChangedAmount(String? value) {
    setState(() {
      _amount = double.parse(value!);
    });
    updateCoinInfo();
  }

  void updateBloc() {
    final bloc = BlocProvider.of<SwapCoinBloc>(context);
    bloc.add(
      DoSwapEvent(
        sourceCoinId: _value,
        targetCoinId: bloc.state.targetCoin?.id ?? widget.coinList[1].id,
        sourceCoinAmount: _amount,
      ),
    );
  }

  void updateCoinInfo() {
    BlocProvider.of<SwapCoinBloc>(context).add(
      ChangeSourceCoin(coinId: _value, sourceCoinAmount: _amount),
    );
  }
}
