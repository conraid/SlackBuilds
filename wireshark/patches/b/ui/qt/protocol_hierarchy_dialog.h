/** @file
 *
 * Wireshark - Network traffic analyzer
 * By Gerald Combs <gerald@wireshark.org>
 * Copyright 1998 Gerald Combs
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#ifndef PROTOCOL_HIERARCHY_DIALOG_H
#define PROTOCOL_HIERARCHY_DIALOG_H

#include <QMenu>

#include "filter_action.h"
#include <ui/qt/models/percent_bar_delegate.h>
#include "wireshark_dialog.h"

class QPushButton;
class QTreeWidgetItem;

namespace Ui {
class ProtocolHierarchyDialog;
}

class ProtocolHierarchyDialog : public WiresharkDialog
{
    Q_OBJECT

public:
    explicit ProtocolHierarchyDialog(QWidget &parent, CaptureFile &cf);
    ~ProtocolHierarchyDialog();

signals:
    void filterAction(QString filter, FilterAction::Action action, FilterAction::ActionType type);

private slots:
    void showProtoHierMenu(QPoint pos);
    void filterActionTriggered();
    void on_actionCopyAsCsv_triggered();
    void on_actionCopyAsYaml_triggered();
    void on_buttonBox_helpRequested();

private:
    Ui::ProtocolHierarchyDialog *ui;
    QPushButton *copy_button_;
    QMenu ctx_menu_;
    PercentBarDelegate percent_bar_delegate_;
    QString display_filter_;

    // Callback for g_node_children_foreach
    static void addTreeNode(GNode *node, gpointer data);
    void updateWidgets();
    QList<QVariant> protoHierRowData(QTreeWidgetItem *item) const;
};

#endif // PROTOCOL_HIERARCHY_DIALOG_H
