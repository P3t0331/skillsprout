import 'package:deadline_tracker/widgets/streambuilder_handler.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:deadline_tracker/models/deadline.dart';
import 'package:deadline_tracker/models/enums/vote.dart';
import 'package:deadline_tracker/services/auth.dart';
import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/utils/date_formatter.dart';
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

  @override
  void initState() {
    super.initState();
    _uid = widget._authService.currentUser!.uid;
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.deadline.title),
                  Text(
                    "Due: " + DateFormatter.formatDate(widget.deadline.date),
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            SizedBox(width: 10),
            Text(
              _voteSum.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            StreamBuilderHandler(
              stream:
                  widget._deadlineService.getUserVote(widget.deadline.id, _uid),
              toReturn: _buildVoteButtons,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoteButtons(AsyncSnapshot<Vote> voteSnapshot) {
    return Column(
      children: [
        GestureDetector(
          onTap:
              widget.enableVoting ? () => _onUpVoteClicked(voteSnapshot) : null,
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
              ? () => _onDownVoteClicked(voteSnapshot)
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

  void _onUpVoteClicked(AsyncSnapshot<Vote> voteSnapshot) {
    if (voteSnapshot.data == Vote.upvote) {
      widget._deadlineService.changeVote(_uid, widget.deadline.id, Vote.none);
    } else {
      widget._deadlineService.changeVote(_uid, widget.deadline.id, Vote.upvote);
    }
  }

  void _onDownVoteClicked(AsyncSnapshot<Vote> voteSnapshot) {
    if (voteSnapshot.data == Vote.downvote) {
      widget._deadlineService.changeVote(_uid, widget.deadline.id, Vote.none);
    } else {
      if (widget.deadline.downvoteIds.length == 2) {
        widget._deadlineService.deleteDeadline(widget.deadline);
      } else {
        widget._deadlineService
            .changeVote(_uid, widget.deadline.id, Vote.downvote);
      }
    }
  }
}
