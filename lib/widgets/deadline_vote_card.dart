import 'package:deadline_tracker/widgets/futurebuilder_handler.dart';
import 'package:deadline_tracker/widgets/streambuilder_handler.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../models/deadline.dart';
import '../models/vote.dart';
import '../services/auth.dart';
import '../services/deadline_service.dart';
import '../utils/date_formatter.dart';
import 'decorated_container.dart';

class DeadlineVoteCard extends StatefulWidget {
  @override
  State<DeadlineVoteCard> createState() => _DeadlineVoteCardState();

  final Deadline deadline;
  final bool enableVoting;
  final _deadlineService = GetIt.I<DeadlineService>();
  final _authService = GetIt.I<Auth>();

  DeadlineVoteCard(
      {super.key, required this.deadline, this.enableVoting = false});
}

class _DeadlineVoteCardState extends State<DeadlineVoteCard> {
  late final String _uid;
  late final Future<String> _deadlineId;

  @override
  void initState() {
    super.initState();
    _uid = widget._authService.currentUser!.uid;
    _deadlineId = widget._deadlineService.getDeadlineId(widget.deadline);
  }

  @override
  Widget build(BuildContext context) {
    final int _voteSum =
        widget.deadline.upvoteIds.length - widget.deadline.downvoteIds.length;

    return DecoratedContainer(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.deadline.title),
                Text(
                  "Due: " + DateFormatter.formatDate(widget.deadline.date),
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            Spacer(),
            Text(
              _voteSum.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            FutureBuilderHandler(
              future: _deadlineId,
              toReturn: (AsyncSnapshot<String> deadlineIdSnapshot) =>
                  StreamBuilderHandler(
                stream: widget._deadlineService
                    .getUserVote(deadlineIdSnapshot.data!, _uid),
                toReturn: (AsyncSnapshot<Vote> voteSnapshot) =>
                    _buildVoteButtons(voteSnapshot, deadlineIdSnapshot),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoteButtons(AsyncSnapshot<Vote> voteSnapshot,
      AsyncSnapshot<String> deadlineIdSnapshot) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.enableVoting
              ? () {
                  if (voteSnapshot.data == Vote.upvote) {
                    widget._deadlineService
                        .changeVote(_uid, deadlineIdSnapshot.data!, Vote.none);
                  } else {
                    widget._deadlineService.changeVote(
                        _uid, deadlineIdSnapshot.data!, Vote.upvote);
                  }
                }
              : null,
          child: Icon(
            Icons.arrow_upward_rounded,
            color: widget.enableVoting
                ? voteSnapshot.data == Vote.upvote
                    ? Colors.orange
                    : Colors.black
                : Colors.grey,
          ),
        ),
        GestureDetector(
          onTap: widget.enableVoting
              ? () {
                  if (voteSnapshot.data == Vote.downvote) {
                    widget._deadlineService
                        .changeVote(_uid, deadlineIdSnapshot.data!, Vote.none);
                  } else {
                    widget._deadlineService.changeVote(
                        _uid, deadlineIdSnapshot.data!, Vote.downvote);
                  }
                }
              : null,
          child: Icon(
            Icons.arrow_downward_rounded,
            color: widget.enableVoting
                ? voteSnapshot.data == Vote.downvote
                    ? Colors.blue
                    : Colors.black
                : Colors.grey,
          ),
        ),
      ],
    );
  }
}
